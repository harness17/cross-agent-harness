# Handoff Example

```md
## 2026-05-17 10:30 追記（設定画面の保存エラー修正 — Claude Code 作成）

- 対象: `feature/settings-save`
- 作成者: Claude Code
- 主題: 設定画面で保存時に 500 が出る問題を Codex が限定修正する
- 触ってよい範囲:
  - `src/settings/*`
  - `tests/settings/*`
- 触ってはいけない範囲:
  - 認証基盤
  - unrelated UI cleanup
- 完成条件:
  - 有効な入力では設定が保存される
  - 不正な入力では user-facing error を返す
  - 認可されていないユーザーは保存できない
  - 既存の設定読み込み動作を壊さない
- 変更内容:
  - 未着手
- セルフ verify:
  - `npm run test`
- 実動確認:
  - 設定画面を開き、保存成功と validation error を確認する
- レビュー観点:
  - 所有者チェックが抜けていないか
  - raw exception を UI に出していないか
  - duplicate submit で二重保存しないか
- 未解決:
  - なし
- 次アクション:
  - Codex が実装修正し、verify 結果をこの handoff に追記する
```
