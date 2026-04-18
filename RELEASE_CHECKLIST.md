# Meshimase リリース準備チェックリスト

App Store にリリースするまでにやるべきことを優先度つきで整理。
所要目安は「1人で進めた場合」。

---

## 🔴 必須（これがないとリリース不可）

### A. 開発アカウント・体制
- [ ] **Apple Developer Program 加入**（年額 $99 / 個人 or 法人）
  - 法人登録なら D-U-N-S ナンバー取得が別途必要（2〜4週間）
- [ ] 支払い口座 / 税務フォーム（W-8BEN）の App Store Connect 登録
- [ ] Bundle ID 予約: `com.meshimase.app`（仮）

### B. Xcode プロジェクト整備
- [ ] `.xcodeproj` 生成（Xcode で New Project → 現ソース移行 or XcodeGen）
- [ ] Code Signing / Provisioning Profile 設定
- [ ] Entitlements（In-App Purchase、Location）
- [ ] Info.plist 最終化（現状 v0.1 なのでバンドルバージョン・権限説明文見直し）

### C. 課金セットアップ
- [ ] App Store Connect で IAP Product 登録
  - 消耗型 `com.meshimase.ticket.single`（100円、税込）
  - 自動更新サブスク `com.meshimase.subscription.monthly`（480円/月）
    - **3日間の無料トライアル** を Introductory Offer で設定
- [ ] Sandbox テストアカウント作成（購入フロー確認用）
- [ ] StoreKit Configuration File（`.storekit`）で Xcode ローカル確認
- [ ] 復元購入（Restore Purchases）導線を設定画面に追加

### D. 法務・プライバシー
- [ ] **プライバシーポリシー**（位置情報の扱い、IAP 履歴など）
  - URL が App Store Connect で必須
  - 無料で Notion / GitHub Pages に掲載でOK
- [ ] **利用規約**（サブスクの自動更新、解約方法を明記）
- [ ] **特定商取引法に基づく表記**（日本で販売者情報の開示義務）
- [ ] App Privacy Labels（App Store Connect で入力）
  - 位置情報: 「App の機能」目的
  - 購入履歴: Apple が扱うので自社収集なし

### E. 必須アセット
- [ ] **App Icon**（1024x1024 PNG、マスクなし、透過なし）
- [ ] Launch Screen（SwiftUI では自動生成可）
- [ ] **App Store スクリーンショット**（6.7" / 6.5" / 5.5" 各サイズ、最低3枚）
- [ ] アプリ名・サブタイトル・キーワード（日本語ローカライズ）
  - 案: 名前 `Meshimase` / サブタイトル `迷ったら、3タップで決まる`
- [ ] 説明文（日本語 / 英語）

### F. 動作確認
- [ ] TestFlight ベータ配布（最低 5〜10 人にテスト）
- [ ] 実機で位置情報の許諾フロー確認
- [ ] 実機で IAP / サブスク購入 → 復元 → 解約の全フロー確認
- [ ] 実機で時間帯判定の境界値テスト（4:00 / 10:30 / 15:00）
- [ ] ダークモード確認
- [ ] VoiceOver（アクセシビリティ）ざっくり確認
- [ ] iPhone SE（小画面）でのレイアウト崩れ確認

---

## 🟡 強く推奨（ないとリスク大）

### G. 計測・分析
- [ ] **Crash Reporting**: Firebase Crashlytics or Sentry
- [ ] **Analytics**: Firebase Analytics or Mixpanel
  - 重要イベント: 起動、気分確定、ロール回数、ペイウォール到達、購入、サブスク加入/解約
  - 3回目到達率を早期に把握できないと価格調整不能
- [ ] App Store Connect の App Analytics（デフォルト有効）

### H. ブランド・マーケティング
- [ ] **ニャシェフの実イラスト**（9 表情、詳細は `CHARACTER.md`）
- [ ] SNS アカウント開設（X / Instagram）
  - ヘッダー / プロフィール画像はニャシェフ
- [ ] **ランディングページ**（プライバシーポリシー URL と兼用可）
  - ダウンロードボタン、スクリーンショット、キャラ紹介
- [ ] プレスキット（PR Times 等に流す場合）
- [ ] ASO キーワード調査（`迷う`, `ランチ`, `晩ごはん`, `ガチャ` 等）

### I. カスタマーサポート
- [ ] サポートメールアドレス（`support@meshimase.app` 等）
- [ ] FAQ ページ（返金、サブスク解約手順、位置情報許諾、等）
- [ ] 問い合わせ導線（設定画面からメール起動）

---

## 🟢 余裕があれば（Phase 1.5 以降でもOK）

- [ ] App 設定画面（通知 / 振動 / テーマ）
- [ ] 履歴機能（過去に提案された料理を遡れる）
- [ ] Widget（ホーム画面から 1タップで提案）
- [ ] Siri Shortcuts
- [ ] Apple Watch アプリ
- [ ] 機械学習でユーザーの好みを学習
- [ ] 多言語対応（英語、繁体字）

---

## 📅 スケジュール目安

| フェーズ | 想定期間 |
|---|---|
| 開発アカウント整備 | 1 週間（法人は 2〜4 週） |
| Xcode プロジェクト整備 + アイコン | 3〜5 日 |
| キャラクターイラスト制作 | 1〜2 週間（外注 or 生成AI） |
| 法務ドキュメント準備 | 3 日 |
| TestFlight ベータ（バグ修正含む） | 2 週間 |
| App Store 審査 | 1〜3 日（リジェクト対応含めて最大 1 週間） |
| **合計** | **おおよそ 1〜1.5 ヶ月** |

---

## ⚠️ 審査で指摘されやすいポイント

1. **サブスクの自動更新の説明**（Paywall 画面に「自動更新、いつでも解約可」の明示必須）
2. **プライバシーポリシー URL** が死んでいると即リジェクト
3. **IAP と「外部決済」を混ぜない**（Apple Pay を表示するのは物理商品購入時のみ、デジタルコンテンツは必ず IAP）
4. **位置情報の使用説明文**（`Info.plist` の `NSLocationWhenInUseUsageDescription`）がユーザー目線かどうか
5. **復元購入導線**がない → リジェクト事例あり
6. **キッズカテゴリに入れる場合**の追加要件（本アプリは対象外）

---

## 🎯 次の具体アクション（優先度順）

1. Apple Developer Program 加入
2. ニャシェフイラスト 1 枚（ニュートラル表情）生成→確認
3. Xcode プロジェクト化
4. プライバシーポリシー下書き
5. Analytics 仕込み
6. TestFlight にβ配布

詳細なステップで進めたい項目があれば、個別に詰めましょう。
