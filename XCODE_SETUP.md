# Xcode セットアップガイド

Meshimase は `.xcodeproj` を Git にコミットせず、**XcodeGen** で `project.yml` から生成する構成にしています。
これにより人間が読める YAML でビルド設定を管理でき、マージ競合を避けられます。

---

## 1. 前提環境

- macOS Sonoma 以降
- Xcode 15.0 以降（iOS 17 SDK 同梱版）
- Homebrew

---

## 2. XcodeGen のインストール

```bash
brew install xcodegen
```

---

## 3. プロジェクトファイルの生成

```bash
cd Meshimase
xcodegen generate
open Meshimase.xcodeproj
```

Xcode が開けば準備完了。

> 💡 `project.yml` を編集したら再度 `xcodegen generate` を実行してください。

---

## 4. Apple Developer Team の設定

`Meshimase/project.yml` 内の `DEVELOPMENT_TEAM` を自身の Team ID に置換してください。

```yaml
settings:
  base:
    DEVELOPMENT_TEAM: "ABCDE12345"  # ← ここ
```

Team ID は [Apple Developer → Membership](https://developer.apple.com/account/#/membership) で確認できます。

置換後、再生成 (`xcodegen generate`) して Xcode で開き直します。

---

## 5. ローカルで課金フローをテストする

本リポジトリには `Meshimase/Meshimase.storekit` を同梱しています。

1. Xcode で左ペインの `Meshimase` スキームを選択
2. **Edit Scheme → Run → Options → StoreKit Configuration** を `Meshimase.storekit` に設定
3. 実行すると、実際の Apple への通信なしで購入フローがテストできます
   - 決断チケット 100円（消耗型）
   - 聞き放題プラン 480円/月（3日間無料トライアル付き）

> 💡 Sandbox テスト（App Store Connect 経由の実地テスト）は TestFlight 配布後でもOKです。

---

## 6. 実行

1. Xcode 上部のデバイス選択で **iPhone 15**（シミュレータ）を選ぶ
2. `⌘R` でビルド＆実行

初回起動時にオンボーディング → ホーム画面へ遷移することを確認してください。

位置情報の許諾ダイアログはシミュレータで以下から疑似位置を送れます:
- シミュレータメニュー → Features → Location → Apple（本社の座標）

---

## 7. ディレクトリ構成

```
Meshimase/
├── project.yml            # XcodeGen 設定（ソースオブトゥルース）
├── Meshimase.storekit     # StoreKit ローカルテスト用
├── Meshimase/             # アプリソース
│   ├── Info.plist
│   ├── MeshimaseApp.swift
│   ├── Models/
│   ├── Views/
│   ├── Services/
│   ├── Resources/
│   │   └── meals.json
│   └── Assets.xcassets/
│       ├── AppIcon.appiconset/      # TODO: 1024x1024 PNG 追加
│       └── AccentColor.colorset/    # オレンジ #FF8A3D
└── Meshimase.xcodeproj/   # 生成物（Git 管理外）
```

---

## 8. 次の TODO

- [ ] `DEVELOPMENT_TEAM` を Team ID に置換
- [ ] App Icon 1024x1024 を `AppIcon.appiconset/` に追加（ニャシェフイラスト完成後）
- [ ] Bundle ID `com.meshimase.app` を Apple Developer で登録
- [ ] App Store Connect で IAP / サブスク Product ID 登録（`Meshimase.storekit` と同じID）
- [ ] 実機で位置情報 + StoreKit を通しで確認
- [ ] TestFlight に配布

---

## 9. トラブルシューティング

### `xcodegen generate` でエラーが出る
`project.yml` の YAML 構文を確認。タブ文字が紛れていないか注意。

### シミュレータで位置情報が取れない
Xcode の Simulator メニュー → Features → Location → 任意の場所を選択。

### 課金画面が表示されない
Scheme 設定の **StoreKit Configuration** が `Meshimase.storekit` になっているか確認。

### プレビューが重い / ビルドが遅い
`build/` と `DerivedData/` を削除してクリーンビルド:
```bash
rm -rf build/ ~/Library/Developer/Xcode/DerivedData/Meshimase-*
```
