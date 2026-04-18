# Analytics ガイド

本アプリの分析計測は「ベンダ非依存」で設計されている。
コードは `AnalyticsService` プロトコルだけに依存しており、
開発時は `ConsoleAnalyticsService`（OSLog 出力）、本番は Firebase / TelemetryDeck / Mixpanel 等に差し替える。

## 構成

- `Services/AnalyticsEvent.swift` - 計測するイベントの型安全な列挙
- `Services/AnalyticsService.swift` - プロトコル + OSLog 実装 + Composite
- `MeshimaseApp.swift` - DI のエントリ。ここだけ差し替えれば本番ベンダに切り替わる

```swift
// MeshimaseApp.swift
private let analytics: AnalyticsService = ConsoleAnalyticsService()

// 本番例:
// private let analytics: AnalyticsService = CompositeAnalyticsService([
//     ConsoleAnalyticsService(),
//     FirebaseAnalyticsService()
// ])
```

## 計測しているイベント一覧

| イベント名 | 発火タイミング | 主要パラメータ |
|------------|----------------|----------------|
| `onboarding_started` | オンボーディング表示 | - |
| `onboarding_completed` | オンボ完了ボタン | - |
| `mood_selected` | 最初のロール押下 | volume, temperature, genre, meal_time |
| `meal_suggested` | 提案が1件確定した直後 | meal_id, roll_count, has_subscription |
| `reroll_attempted` | 「もう一回」押下 | roll_count, has_subscription, blocked_by_paywall |
| `pre_charge_alert_shown` | 課金前ダイアログ表示 | - |
| `pre_charge_alert_action` | ダイアログの選択 | action (single / subscribe / cancel) |
| `purchase_started` | 購入フロー開始 | product_id, source |
| `purchase_completed` | 購入成功 | product_id, source |
| `purchase_cancelled` | ユーザキャンセル | product_id, source |
| `purchase_failed` | 購入失敗 | product_id, source, reason |
| `meal_decided` | 「これで決まり」押下 | meal_id, total_rolls |
| `restaurant_opened` | 店舗行をタップ | index, distance_meters |
| `session_ended` | 気分選び直し or 終了 | total_rolls, decided |
| `location_permission_changed` | 位置情報権限変化 | status |
| `restaurant_search_failed` | 店舗検索失敗 | reason |

`source` は `pre_charge_dialog` / `paywall` のどちらから起きた購入かを示す。

## ファネルのキー指標

1. `onboarding_started` → `onboarding_completed` 完了率
2. `mood_selected` → `meal_decided` 決定率
3. `reroll_attempted`（blocked=true）→ `pre_charge_alert_action`（single / subscribe）変換率
4. `purchase_started` → `purchase_completed` 成功率（source 別）
5. `meal_decided` → `restaurant_opened` 送客率

## Firebase Analytics への差し替え手順

### 1. Swift Package を追加

Xcode → File → Add Packages… で以下を追加:
```
https://github.com/firebase/firebase-ios-sdk
```
必要プロダクト:
- `FirebaseAnalytics`
- `FirebaseCrashlytics`（推奨）

### 2. `GoogleService-Info.plist` を配置

Firebase Console で iOS アプリを作成し、`GoogleService-Info.plist` を
`Meshimase/Meshimase/` 直下に追加（Target Membership に含める）。

### 3. Firebase 実装を作成

`Services/FirebaseAnalyticsService.swift` を新規作成:

```swift
import FirebaseCore
import FirebaseAnalytics

final class FirebaseAnalyticsService: AnalyticsService {
    init() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }

    func track(_ event: AnalyticsEvent) {
        Analytics.logEvent(event.name, parameters: event.parameters)
    }

    func screen(_ name: String) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: name
        ])
    }

    func setUserProperty(_ key: String, value: String?) {
        Analytics.setUserProperty(value, forName: key)
    }
}
```

### 4. 差し替え

`MeshimaseApp.swift`:

```swift
private let analytics: AnalyticsService = CompositeAnalyticsService([
    ConsoleAnalyticsService(),
    FirebaseAnalyticsService()
])
```

これだけで全イベントが Firebase へ流れる。アプリ側のコード変更は不要。

## TelemetryDeck への差し替え（参考）

App Store の表記負荷が軽く、個人開発向け:

```
https://github.com/TelemetryDeck/SwiftClient
```

```swift
import TelemetryClient

final class TelemetryDeckService: AnalyticsService {
    init(appID: String) {
        let config = TelemetryManagerConfiguration(appID: appID)
        TelemetryManager.initialize(with: config)
    }
    func track(_ event: AnalyticsEvent) {
        TelemetryManager.send(event.name, with: event.parameters.mapValues { "\($0)" })
    }
    func screen(_ name: String) { track(.init(rawName: "screen_\(name)")) }
    func setUserProperty(_ key: String, value: String?) { /* 省略 */ }
}
```

## プライバシー関連の注意

- App Store Connect の「App のプライバシー」で収集項目を必ず申告
- `PRIVACY.md` に利用ベンダと目的を明記
- IDFA は使わない前提（使う場合は ATT プロンプトが必要）
- ユーザ ID は匿名化。購入金額以外のセンシティブ情報は送らない

## デバッグ

Xcode 実行中に Console.app を開き、サブシステム `Meshimase` / カテゴリ `analytics` で
フィルタすれば `event=... params=...` の行が流れる。
