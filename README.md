# cross-agent-harness

Codex と Claude Code を同じリポジトリで運用するための、軽量な共同開発ハーネスです。

AI エージェントを複数使うと、便利な一方で「どちらが何を触ってよいか」「レビュー結果をどこに残すか」「merge 前に何を確認するか」が曖昧になりがちです。`cross-agent-harness` は、その境界と handoff をプロジェクトへ移植するためのキットです。

## できること

- Codex と Claude Code の担当境界をプロジェクトごとに明文化する
- `CLAUDE_CODE_HANDOFF.md` に実装依頼、レビュー、検証結果を残す
- merge / publish 前の確認条件を固定する
- 共通ルールとプロジェクト固有 profile を分けて再利用する

## 導入

このリポジトリを clone したディレクトリで、対象プロジェクトを指定して実行します。

```powershell
.\install.ps1 -TargetPath C:\Projects\MyApp -ProjectName MyApp
```

macOS / Linux から使う場合も、PowerShell 7 があれば同じスクリプトを使えます。

```powershell
pwsh ./install.ps1 -TargetPath /path/to/my-app -ProjectName MyApp
```

既存の `project-collaboration-profile.md` と `CLAUDE_CODE_HANDOFF.md` は、`-Force` を付けない限り上書きしません。

```powershell
.\install.ps1 -TargetPath C:\Projects\MyApp -ProjectName MyApp -Force
```

## コピーされるファイル

```text
.claude/rules/cross-agent-harness.md
.claude/rules/handoff-protocol.md
.claude/rules/project-collaboration-profile.md
.claude/skills/codex-handoff/SKILL.md
.claude/skills/cross-review/SKILL.md
.agents/skills/implement-task/SKILL.md
CLAUDE_CODE_HANDOFF.md
```

## 導入後の設定

まず対象プロジェクトの `.claude/rules/project-collaboration-profile.md` を埋めます。

最低限、次を設定してください。

- プロジェクト種別
- 通常の verify コマンド
- UI や実動確認が必要な場合の確認方法
- Codex と Claude Code の担当境界
- merge / publish ブロッカーにする重大指摘

次に、対象プロジェクトの `CLAUDE.md` に以下を追加します。

```md
@.claude/rules/cross-agent-harness.md
@.claude/rules/project-collaboration-profile.md
@.claude/rules/handoff-protocol.md
```

対象プロジェクトの `AGENTS.md` には、以下の要旨を追加します。

```md
## 共同開発ハーネス

Codex は作業開始時に `CLAUDE_CODE_HANDOFF.md` の最新セクションを読み、
`.agents/skills/implement-task/SKILL.md` と
`.claude/rules/project-collaboration-profile.md` に従って作業する。
```

## 運用フロー

1. Claude Code が `CLAUDE_CODE_HANDOFF.md` に実装依頼を書く
2. Codex が handoff、profile、対象差分を読んで限定範囲を実装する
3. Codex が verify 結果と残リスクを handoff に追記する
4. Claude Code が `/cross-review` でレビューする
5. merge / publish 前に次の 4 条件を確認する

```text
1. セルフ verify 済み
2. 反対側レビュー済み
3. 重大指摘なし
4. user が merge / publish を明示
```

handoff の記入例は [examples/handoff-example.md](examples/handoff-example.md) を参照してください。

## 設計方針

- 共通ルールは `.claude/rules/cross-agent-harness.md` に置く
- プロジェクト固有の検証、重大指摘、担当境界は `project-collaboration-profile.md` に置く
- 作業ログと次アクションは `CLAUDE_CODE_HANDOFF.md` に集約する
- エージェント同士が同じファイルを同時に直す場合は、推測で上書きせずユーザーへ確認する

## ライセンス

MIT License
