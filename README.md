# Meshimase（めしませ）
**迷ったら、Meshimase.**

朝/昼/夜のごはんを迷わず決められる iOS アプリ。
気分を3つ選ぶと、マスコット "ニャシェフ" がランダムに1品提案し、決まれば近くのお店まで案内します。

## ステータス
MVP 実装中（SwiftUI / iOS 17+）

## ドキュメント
- `OVERVIEW.md` - **サービス概要**（最初に読む）
- `SPEC.md` - 機能仕様書
- `CHARACTER.md` - キャラクター（ニャシェフ）設計書／画像生成プロンプト
- `RELEASE_CHECKLIST.md` - リリース準備チェックリスト
- `XCODE_SETUP.md` - **Xcode プロジェクトの立ち上げ手順**
- `mockups/index.html` - 画面モックアップ（ブラウザで開く）

### 法務ドキュメント（公開用下書き）
- `PRIVACY.md` - プライバシーポリシー
- `TERMS.md` - 利用規約
- `TOKUSHOHO.md` - 特定商取引法に基づく表記

## 構成
- `Meshimase/` - iOS アプリ
  - `project.yml` - XcodeGen 設定（`.xcodeproj` のソース）
  - `Meshimase.storekit` - StoreKit ローカルテスト設定
  - `Meshimase/` - アプリソース
    - `Models/` - データモデル
    - `Views/` - UIレイヤ
    - `Services/` - IAP / 位置情報 / 店舗検索 / メッセージ
    - `Resources/` - メニューJSON等
    - `Assets.xcassets/` - アイコン / カラー

## 開発セットアップ
詳細は `XCODE_SETUP.md` 参照。
```bash
brew install xcodegen
cd Meshimase
xcodegen generate
open Meshimase.xcodeproj
```

## ブランチ
`claude/meal-suggestion-app-3Wg3U`
