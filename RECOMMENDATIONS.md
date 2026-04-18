# おすすめツール / サービス

Meshimase を個人〜小規模チームで運営する前提で、
ライフサイクル別に「いま入れておくと楽」な選択肢をまとめた。
★ は特に個人開発相性が良いもの。

## 1. 開発基盤

| カテゴリ | 推奨 | 理由 |
|----------|------|------|
| プロジェクト生成 | **XcodeGen** ★ | `project.yml` で `.xcodeproj` を再生成。PRレビューしやすく差分が小さい |
| 依存管理 | **Swift Package Manager** | Xcode 標準。Firebase / StoreKit Test も SPM 対応 |
| Lint | **SwiftLint** | `.swiftlint.yml` で最低限（force_cast / unused_import 等）を弾く |
| Format | **swift-format**（Apple 公式） | CI で `--mode lint` を回すだけでも可読性向上 |
| エラー監視 | **Crashlytics** または **Sentry** ★ | Sentry は無料枠が広く Swift SDK が軽い |

## 2. 分析（Analytics）

コードはベンダ非依存（`ANALYTICS.md` 参照）。選択肢:

| ツール | 向き | コメント |
|--------|------|----------|
| **Firebase Analytics** | 無料で大量イベントを捌きたい | Crashlytics と一体。ダッシュボードは癖あり |
| **TelemetryDeck** ★ | プライバシー重視・個人開発 | 月額制、IDFA不要、App Store 申告が軽い |
| **Mixpanel** | ファネル/リテンション分析を深くやる | 無料枠あり、有償はやや高い |
| **PostHog** | 自前ホストもしたい / セッションリプレイ | オープンソース、機能豊富 |

迷ったら **Firebase + TelemetryDeck の併用**（Composite でデュアル配信）がおすすめ。

## 3. 課金 / サブスクリプション

| ツール | 向き | コメント |
|--------|------|----------|
| **StoreKit 2 のみ** | 1アプリ・1ストア | 追加コストなし。今の実装はこれ |
| **RevenueCat** ★ | 複数ストア・サブスク運用本気 | 収益ダッシュボード・チャーン分析・A/B テスト付き。月5K ドルまで無料 |
| **Glassfy** | RevenueCat の代替・安価 | 機能は近く、より軽量 |

**サブスクを本格運用するなら RevenueCat を強く推奨**（解約率把握・返金・プロモオファー管理が段違いに楽）。

## 4. CI / CD

| ツール | 向き | コメント |
|--------|------|----------|
| **GitHub Actions** ★ | OSS / 個人 | macOS ランナー有料だが時間単位で十分 |
| **Xcode Cloud** | Apple エコシステム完結 | 25h/月 無料。TestFlight 配信が1クリック |
| **Fastlane** | 補助 | `match` で証明書同期、`pilot` で TestFlight 自動化 |
| **Bitrise** | 大人数チーム | Apple 周辺が手厚いが有料 |

個人開発なら **Xcode Cloud**（TestFlight 配信まで含めて完結）が最も手軽。

## 5. デザイン / アセット

| ツール | 用途 |
|--------|------|
| **Figma** ★ | 画面設計、アイコンの下書き、モックアップ |
| **SF Symbols** ★ | アイコン統一感。現状多用している |
| **Bakery / IconKitchen** | アプリアイコンの量産 |
| **Lottie** | アニメーション（決定演出・紙吹雪など） |
| **Rive** | インタラクティブアニメ（Lottie より動的） |
| **Midjourney / DALL·E / SD** | キャラクター挿絵（`CHARACTER.md` のプロンプト利用） |

## 6. マーケティング / ASO

| ツール | 用途 |
|--------|------|
| **App Store Connect** | 標準。ローカライズ・スクショ・プロモコード |
| **AppFollow** / **Sensor Tower** | 競合・キーワードリサーチ |
| **Screenshot Maker**（figma プラグイン） | スクショ量産 |
| **App Preview 動画** | 30秒。コンバージョン向上に強い |

ASO の初手は「日本語キーワード最適化 + スクショ1枚目」だけで十分効く。

## 7. サポート / コミュニティ

| ツール | 用途 |
|--------|------|
| **Tally** / **Google Forms** ★ | お問い合わせフォーム（`TOKUSHOHO.md` に貼る） |
| **Discord** / **Zenn / X(Twitter)** | ユーザコミュニティと速報 |
| **Canny** | ロードマップ公開・要望投票 |

Canny までは早すぎ。まずはフォーム + X の DM で十分。

## 8. ドキュメント / ナレッジ

| ツール | 用途 |
|--------|------|
| **Notion** | 社内仕様・進行管理 |
| **GitHub Pages** ★ | プライバシーポリシー公開（現状モックアップ公開済） |
| **Obsidian / Bear** | 個人メモ |

## 9. 法務 / 会社・個人事業主

| ツール | 用途 |
|--------|------|
| **freee** / **マネーフォワード** | 青色申告・インボイス |
| **Stripe Atlas** | 将来米国法人化 |
| **iubenda** | 多言語対応プライバシーポリシー自動生成（海外展開時） |

## 10. 本アプリでの "次の一手" 推奨順

1. **Xcode Cloud** を有効化して TestFlight へ配信（審査前の社内配布を即できるように）
2. **Sentry または Crashlytics** を入れてクラッシュ・ANR を可視化
3. **TelemetryDeck** を `CompositeAnalyticsService` に追加（個人開発向けに軽い）
4. **RevenueCat** への移行検討（サブスク LTV を測れるようにする）
5. スクショ + App Preview を Figma で量産、ASO A/B テスト開始
6. **Lottie** で「提案アニメ」を強化（決まった瞬間の演出）

コストかけずに効く順に並べた。まず 1〜3 を先に入れると運用が一気に楽になる。
