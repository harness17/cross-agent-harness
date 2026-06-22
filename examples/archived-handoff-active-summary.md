# Archived Handoff Active Summary Example

active handoff を短く保ち、完了履歴を archive へ分離する例です。

```md
# MyApp 共同開発ハンドオフ

最終更新: 2026-06-22
対象リポジトリ: `<repo-root>`
status: idle

このファイルは次の担当者が作業開始時に読むアクティブな引き継ぎだけを保持する。
完了済みの履歴は
[`docs/handoffs/archive/2026-06-summary.md`](docs/handoffs/archive/2026-06-summary.md)
を参照する。

## 現在の状態

- ブランチ: `develop`
- アクティブなエージェント間委譲: なし
- merge / publish 指示: なし
- worktree: 既存未コミット差分あり。今回の作業と無関係な変更を巻き戻さない

## 2026-06-22 設定画面の保存エラー修正（Codex 実装 / Claude Code レビュー）

### 目的

設定画面で 500 を返す保存経路を限定修正する。

### verify コマンド

```powershell
npm run test -- settings
npm run lint
```

### 次に確認すること

1. Claude Code が review で重大指摘有無を確定する
2. user が merge 可否を判断する

## 運用

- 完了した委譲は要約して `docs/handoffs/archive/` へ移す
- 先頭の `最終更新` と `対象リポジトリ` は追記のたびに同期する
- `N/A と理由` を残した verify は次担当者がそのまま判定できる粒度で書く
```
