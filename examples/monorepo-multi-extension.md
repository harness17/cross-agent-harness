# Monorepo Multi-Extension Profile Example

`project-collaboration-profile.md` の記入例です。複数のブラウザ拡張を 1 つの root repo で管理しつつ、タスクごとに verify を切り替える想定です。

```md
# Project Collaboration Profile（BrowserExtensions）

`cross-agent-harness.md` を BrowserExtensions に適用するためのプロジェクト固有設定。

## プロジェクト

- 名前: BrowserExtensions
- 種別: Manifest V3 browser extensions monorepo
- 主な検証対象: `amazon-wishlist-sale-picker/`、`youtube-playlist-date-sorter/`、`kindle-series-sale-tracker/`
- 注意領域: permissions、host permissions、store package、ログイン必須サイト fixture、公開物への個人情報混入

## 担当境界

| 条件 | 振り先 |
|------|--------|
| 単一拡張内の content / popup / fixture 修正 | Codex |
| 複数拡張にまたがる構成変更、manifest 戦略、store 提出判断 | Claude Code + user |
| 実ブラウザ確認、ログイン済みページ素材採取 | user が素材提供、実装者が fixture 化 |

## Verify コマンド

通常のセルフ verify:

```powershell
Push-Location .\amazon-wishlist-sale-picker
node .\verify-detect.mjs
Pop-Location
```

変更種別ごとの追加 verify:

```text
- youtube-playlist-date-sorter を触ったら `cd youtube-playlist-date-sorter && node ./verify-date-sorter.mjs`
- kindle-series-sale-tracker を触ったら `cd kindle-series-sale-tracker && node ./verify-kindle-library.mjs`
- root scripts や packaging を触ったら関係する全 extension の verify を回す
```

実動確認が必要な場合:

```text
chrome://extensions/ または about:debugging で対象拡張だけを再読み込みし、変更箇所を確認する。
```

manual gate:

- store package、screenshot、listing、権限追加は user 明示まで merge / publish しない
- ログイン必須ページの回帰は fixture 化できない限り `N/A と理由` を handoff に残す
```
