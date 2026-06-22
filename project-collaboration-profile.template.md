# Project Collaboration Profile（{{PROJECT_NAME}}）

`cross-agent-harness.md` をこのプロジェクトに適用するためのプロジェクト固有設定。

## プロジェクト

- 名前: {{PROJECT_NAME}}
- 種別: TODO（例: ASP.NET Core MVC / Electron + React / Zenn 記事リポジトリ）
- 主な検証対象: TODO（例: Controller / Service / UI / tests / docs）
- 注意領域: TODO（例: 認可、個人情報、外部 API quota、公開フラグ）

## 担当境界

| 条件 | 振り先 |
|------|--------|
| 仕様が明確で、触るファイルが限定される | Codex |
| 複数モジュール・永続化・外部契約をまたぐ設計判断 | Claude Code |
| 実動確認が必要な UI / デスクトップ / ブラウザ変更 | TODO |
| リリース・公開・配布判断 | TODO |

## Verify コマンド

通常のセルフ verify:

```bash
TODO
```

変更種別ごとの追加 verify:

```text
TODO（例: このサブプロジェクトを触ったらこの verify、この packaging を触ったら全体 verify）
```

実動確認が必要な場合:

```bash
TODO
```

manual gate:

- TODO（例: release / publish / screenshot / store listing は user 明示まで進めない）
- 実行不能な verify がある場合は `N/A と理由` を handoff に残す

## レビュー観点

### 動作

- 完成条件を満たしているか
- 既存機能を壊していないか
- エラー処理・境界値の扱いに穴がないか

### 契約

- API / UI / DB / ファイル形式 / 外部サービスなど、project contract が呼び出し側と一致しているか

### テスト

- 完成条件に対応するテストが追加・更新されているか
- project profile の verify コマンドが pass するか
- task-scoped verify が必要な変更なのに通常 verify だけで終わっていないか

### セキュリティ・運用

- TODO（例: 認可、所有者チェック、secret、個人情報、quota、公開フラグ）

### スタイル

- 既存のコード・文書スタイルに揃っているか
- unrelated cleanup や依頼外ファイル変更が混ざっていないか

## プロジェクト固有の重大指摘

以下は原則として merge / publish ブロッカーにする。

- TODO
- handoff の `対象リポジトリ`、verify、担当境界が実体とずれている
