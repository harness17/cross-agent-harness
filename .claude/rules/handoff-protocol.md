# Handoff Protocol

`CLAUDE_CODE_HANDOFF.md` は Codex と Claude Code の共有作業ログ。最新の追記を上に置く。

## 追記するタイミング

- 片方のエージェントへ実装、レビュー、検証を渡すとき。
- 設計方針、触ってよい範囲、検証条件が変わったとき。
- ブロッカー、競合、未解決リスクが出たとき。
- 作業完了時に次の担当者が迷う情報があるとき。

## 追記テンプレート

```md
## YYYY-MM-DD HH:mm 追記（<主題> — <agent> 作成）

- 対象: <branch / worktree / path>
- 作成者: <Codex | Claude Code | user>
- 主題: <一文>
- 触ってよい範囲: <files / directories>
- 触ってはいけない範囲: <unrelated files / user changes>
- 削除すべきファイル: <置き換え対象 / 廃止コンポーネント。なければ「なし」と明記>
- 完成条件:
  - <normal behavior>
  - <preconditions / auth / usage>
  - <error handling>
  - <no-regression checks>
- 層を跨ぐ契約（該当する場合）:
  - 契約名 / 種別: <例: IPC channel `xxx:fetch` / REST `GET /api/yyy` / service method `ZzzService.run`>
  - 実装ファイル: <発火側 / 受信側のファイルパス>
  - 公開層 / 呼び出し元: <preload exposure・SDK 関数・controller など>
  - request / response または event payload: <型と必須フィールド>
  - error / permission: <想定エラー、認可条件>
  - 互換性確認: <既存呼び出し元への影響、後方互換の要否>
  - 片側のみの場合は `N/A: 理由` を明記する（例: fire-and-forget の event、廃止予定 API）。
- 変更内容:
  - <summary>
- セルフ verify: <command and result>
  - 依存プロセス（dev サーバ等）が原因で全体 verify が止まった場合、targeted な部分実行は暫定の切り分けに留める。merge / publish 前は依存プロセスを停止して全体 verify を再実行する。再実行で通らない限り merge ゲートは未達扱いとし handoff に明記する。
- 実動確認: <method and result or N/A>
- レビュー観点:
  - <risk-focused checks>
- 未解決:
  - <questions / blockers>
- 次アクション:
  - <one concrete action>
```

## 書き方

- secret、個人情報、環境固有 token は書かない。
- 「何をしたか」だけでなく「次に何を見ればよいか」を書く。
- 検証未実行を成功扱いしない。
- 同じ主題の handoff がある場合は重複作成より追記を優先する。
