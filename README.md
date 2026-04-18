# Meshimase（めしませ）
**迷ったら、Meshimase.**

朝/昼/夜のごはんを迷わず決められる iOS アプリ。
気分を3つ選ぶと、マスコット "ニャシェフ" がランダムに1品提案し、決まれば近くのお店まで案内します。

## ステータス
MVP 実装中（SwiftUI / iOS 17+）

## ドキュメント
- `SPEC.md` - 機能仕様書
- `CHARACTER.md` - キャラクター（ニャシェフ）設計書／画像生成プロンプト

## 構成
- `Meshimase/` - iOS アプリソース（SwiftUI）
  - `Models/` - データモデル
  - `Views/` - UIレイヤ
  - `Services/` - IAP / 位置情報 / 店舗検索 / メッセージ
  - `Resources/` - メニューJSON等

## 開発セットアップ
1. Xcode 15+ で `Meshimase.xcodeproj` を開く
2. 実機 or シミュレータで Run

## ブランチ
`claude/meal-suggestion-app-3Wg3U`
