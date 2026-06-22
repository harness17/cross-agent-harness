param(
    [Parameter(Mandatory = $true)]
    [string]$TargetPath,

    [string]$ProjectName,

    [switch]$Force
)

$ErrorActionPreference = "Stop"

$kitRoot = $PSScriptRoot
$sourceRoot = Resolve-Path $kitRoot

if (-not (Test-Path $TargetPath)) {
    New-Item -ItemType Directory -Force -Path $TargetPath | Out-Null
}

$targetRoot = Resolve-Path $TargetPath

if (-not $ProjectName) {
    $ProjectName = Split-Path -Leaf $targetRoot
}

function Copy-HarnessFile {
    param(
        [string]$SourceRelative,
        [string]$TargetRelative,
        [switch]$NoOverwrite
    )

    $source = Join-Path $sourceRoot $SourceRelative
    $target = Join-Path $targetRoot $TargetRelative
    $targetDir = Split-Path -Parent $target

    if (-not (Test-Path -LiteralPath $source)) {
        throw "source file not found: $SourceRelative"
    }

    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

    if ($NoOverwrite -and (Test-Path $target) -and -not $Force) {
        Write-Host "skip existing: $TargetRelative"
        return
    }

    Copy-Item -LiteralPath $source -Destination $target -Force
    Write-Host "copied: $TargetRelative"
}

function Write-Template {
    param(
        [string]$TemplateRelative,
        [string]$TargetRelative,
        [switch]$NoOverwrite
    )

    $template = Join-Path $kitRoot $TemplateRelative
    $target = Join-Path $targetRoot $TargetRelative
    $targetDir = Split-Path -Parent $target

    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

    if ($NoOverwrite -and (Test-Path $target) -and -not $Force) {
        Write-Host "skip existing: $TargetRelative"
        return
    }

    $content = [System.IO.File]::ReadAllText($template, [System.Text.UTF8Encoding]::new($false, $true))
    $content = $content.Replace("{{PROJECT_NAME}}", $ProjectName)
    $content = $content.Replace("{{TARGET_PATH}}", $targetRoot.Path.Replace("\", "/"))

    [System.IO.File]::WriteAllText($target, $content, [System.Text.UTF8Encoding]::new($false))
    Write-Host "created: $TargetRelative"
}

function Test-HarnessWarnings {
    param(
        [string]$RootPath
    )

    $warnings = [System.Collections.Generic.List[string]]::new()
    $profilePath = Join-Path $RootPath ".claude\rules\project-collaboration-profile.md"
    $handoffPath = Join-Path $RootPath "CLAUDE_CODE_HANDOFF.md"

    if (Test-Path $profilePath) {
        $profileText = [System.IO.File]::ReadAllText($profilePath, [System.Text.UTF8Encoding]::new($false, $true))
        foreach ($token in @("TODO", "YYYY-MM-DD", "<agent>", "<repo-root>")) {
            if ($profileText.Contains($token)) {
                $warnings.Add("profile still contains placeholder: $token")
            }
        }
    }

    if (Test-Path $handoffPath) {
        $handoffText = [System.IO.File]::ReadAllText($handoffPath, [System.Text.UTF8Encoding]::new($false, $true))
        foreach ($token in @("TODO", "YYYY-MM-DD", "<agent>", "<repo-root>")) {
            if ($handoffText.Contains($token)) {
                $warnings.Add("handoff still contains placeholder: $token")
            }
        }

        $targetLine = [regex]::Match($handoffText, '対象リポジトリ:\s*`([^`]+)`')
        if ($targetLine.Success) {
            $expected = $RootPath.Replace("\", "/")
            if ($targetLine.Groups[1].Value -ne $expected) {
                $warnings.Add("handoff target repo mismatch: expected $expected")
            }
        }
    }

    return $warnings
}

Copy-HarnessFile ".claude\rules\cross-agent-harness.md" ".claude\rules\cross-agent-harness.md"
Copy-HarnessFile ".claude\rules\handoff-protocol.md" ".claude\rules\handoff-protocol.md"
Copy-HarnessFile ".claude\skills\codex-handoff\SKILL.md" ".claude\skills\codex-handoff\SKILL.md"
Copy-HarnessFile ".claude\skills\codex-dev\SKILL.md" ".claude\skills\codex-dev\SKILL.md"
Copy-HarnessFile ".claude\skills\cross-review\SKILL.md" ".claude\skills\cross-review\SKILL.md"
Copy-HarnessFile ".agents\skills\implement-task\SKILL.md" ".agents\skills\implement-task\SKILL.md"
Copy-HarnessFile "scripts\invoke-claude-review.ps1" "scripts\invoke-claude-review.ps1"

Write-Template "project-collaboration-profile.template.md" ".claude\rules\project-collaboration-profile.md" -NoOverwrite
Write-Template "CLAUDE_CODE_HANDOFF.template.md" "CLAUDE_CODE_HANDOFF.md" -NoOverwrite

$warnings = Test-HarnessWarnings -RootPath $targetRoot.Path

Write-Host ""
Write-Host "Next steps:"
Write-Host "1. Fill .claude/rules/project-collaboration-profile.md"
Write-Host "2. Add these lines to CLAUDE.md:"
Write-Host "   @.claude/rules/cross-agent-harness.md"
Write-Host "   @.claude/rules/project-collaboration-profile.md"
Write-Host "   @.claude/rules/handoff-protocol.md"
Write-Host "3. Add a short AGENTS.md section that tells Codex to read CLAUDE_CODE_HANDOFF.md and .agents/skills/implement-task/SKILL.md"
Write-Host "4. Optional: run scripts\invoke-claude-review.ps1 from Codex to append a Claude Code review to CLAUDE_CODE_HANDOFF.md"
if ($warnings.Count -gt 0) {
    Write-Host ""
    Write-Host "Warnings:" -ForegroundColor Yellow
    foreach ($warning in $warnings) {
        Write-Host "- $warning" -ForegroundColor Yellow
    }
}
