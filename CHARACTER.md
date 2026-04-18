# Meshimase キャラクター設計書

本書は画像生成ツール（Midjourney / DALL·E / Stable Diffusion など）やイラストレーターへ
そのまま渡せるキャラクター仕様。迷ったら本書に立ち返ること。

---

## 1. キャラクター概要

| 項目 | 値 |
|---|---|
| 名前 | **ニャシェフ**（Nyashef） |
| 種族 | 猫の料理人（擬人化 2頭身〜3頭身） |
| 性別 | なし（ジェンダーレス） |
| 年齢感 | 青年期（人間換算 25〜30 相当、落ち着いた猫） |
| 役割 | ユーザーのごはんを決めるお店の "シェフ" |
| 立ち位置 | アプリのナビゲーター兼公式マスコット（SNS 看板兼用） |

### 性格
- ツンデレ料理人。基本はぶっきらぼう、でも面倒見が良い
- 「迷ってる暇に作るめし！」が口癖
- プライドが高く職人気質。自分の提案は絶対に美味いと信じている
- でも優柔不断な客には渋々付き合ってくれる（3回以上迷うと決断料を請求する理由）

### 口調（重要）
- 語尾に「**〜めし**」「**〜めしませ**」を付ける
- 丁寧語混じりのぶっきらぼう口調
- 例: 「これなんて、どうめしませ？」「優柔不断だなあ…お代いただくめし」

---

## 2. ビジュアル仕様

### 体型
- 2.5頭身（デフォルメ強め、SNSアイコン映え重視）
- 立ち姿・座り姿・厨房立ち絵の3型を想定

### 顔
- 丸く、ふっくらした猫顔
- ジト目 or 半眼（ツンデレ感を出す）
- 耳は立ち耳、片耳が少し折れていると特徴的
- 頬に小さな肉球模様（アイコン識別性のため）

### 体色・毛色
- ベース: **クリーム×白**（配膳しやすい、清潔感）
- 耳先・尻尾先: **こげ茶**（アクセント）
- 鼻: 小さなピンク
- 目: **琥珀色 (#D4A04A)**

### 服装（コスチューム）
- 白いコックコート（ダブルブレスト、ボタン2列）
- コックコートは **少し大きめに着崩してる**（袖まくり、襟元ゆるめ）
- 首元に **オレンジのバンダナ**（アプリのブランドカラー）
- コック帽は **かぶっていない**（代わりに頭に小さな肉球マークのバッジ）
- 下はシンプルな黒い前掛け or パンツ

### 小物
- しゃもじ or お玉（片手に持つパターン）
- 丸眼鏡（任意、職人感が出る）

### プロポーション注意点
- 手足は短めでコロンとした印象
- 尻尾は太めでふさふさ、動きで感情表現に使う

---

## 3. カラーパレット

| 用途 | カラー | HEX |
|---|---|---|
| 毛（ベース） | クリーム | `#F4E4C1` |
| 毛（白部分） | オフホワイト | `#FAF7F0` |
| 毛（こげ茶アクセント） | ダークブラウン | `#5C3A21` |
| 瞳 | 琥珀 | `#D4A04A` |
| 鼻 | ピンク | `#E8A0A0` |
| バンダナ（ブランドカラー） | メシマセ・オレンジ | `#FF8A3D` |
| コックコート | オフホワイト | `#FAF7F0` |
| 肉球 | サーモンピンク | `#F5B8A8` |
| 影 | ウォームグレー | `#8A7A6C` |

アプリの UI オレンジ (`.orange` / `#FF8A3D`) とバンダナを同色にし、
アプリ内でもキャラが馴染むようにする。

---

## 4. 表情バリエーション（必須セット）

アプリ内の各状態に合わせて必要な表情。9種類を最初に作るのが理想。

| # | 状態 | 表情 | 使用場所 |
|---|---|---|---|
| 1 | ニュートラル | 半眼、口は「へ」の字 | オンボーディング・ホーム |
| 2 | 提案（1回目） | 自信あり、片手でサーブ | 1回目のロール |
| 3 | 提案（2回目） | 少しジト目、腕組み | 2回目のロール |
| 4 | 煽り（3回目以降） | ニヤリ、指を立てて「チャリンッ」 | 3回目+ の煽り |
| 5 | 警告（決断料） | 片手で「ストップ」、片手を差し出す | 事前警告ダイアログ |
| 6 | 決定！（嬉しい） | 目をキラキラ、両手でガッツポーズ風 | 「これにする」押下時 |
| 7 | お店案内 | しゃもじで指し示すポーズ | 店舗リスト上部 |
| 8 | 諦め | ため息、目を伏せる | 「やめる」押下時 |
| 9 | サブスクアピール | ウインク、親指立て | Paywall 画面 |

---

## 5. アプリ内アセット配置計画

| アセット名 | サイズ | 用途 |
|---|---|---|
| `nyashef_icon` | 1024x1024 PNG（不透明） | App Icon（全表情1番） |
| `nyashef_neutral` | 512x512 透過 PNG | オンボーディング1ページ目 |
| `nyashef_greet_morning/lunch/dinner` | 512x512 透過 PNG | ホーム挨拶（時間帯違い・衣装アクセント変更可） |
| `nyashef_roll_1/2/3+` | 512x512 透過 PNG | 提案カード上の表情 |
| `nyashef_warn` | 512x512 透過 PNG | 決断料警告ダイアログ |
| `nyashef_confirmed` | 512x512 透過 PNG | 決定時 |
| `nyashef_restaurants` | 512x512 透過 PNG | 店舗リスト |
| `nyashef_subscription` | 512x512 透過 PNG | Paywall |
| `nyashef_launch_splash` | 1290x2796（iPhone 15 Pro Max 相当） | スプラッシュ |

### SNS / マーケティング用
| アセット | サイズ | 用途 |
|---|---|---|
| `nyashef_twitter_header` | 1500x500 | X ヘッダー（横長・厨房背景） |
| `nyashef_instagram_post` | 1080x1080 | Instagram 投稿 |
| `nyashef_sticker_pack` | 512x512 x 16 | LINE スタンプ（将来） |

---

## 6. イメージ生成プロンプト

### 6-1. Midjourney 用（推奨：v6, --ar 1:1 --style raw）

**英語プロンプト（基本）:**
```
chibi mascot character of a chef cat called "Nyashef", 2.5-head proportion,
cream and white fur with dark brown ear tips and tail tip, amber eyes, small pink nose,
slightly folded left ear, tiny paw-pad birthmarks on cheeks,
wearing an oversized white double-breasted chef coat with rolled-up sleeves,
orange bandana (#FF8A3D) around neck, no chef hat, holding a wooden rice scoop,
tsundere expression (half-lidded eyes, slight smirk), flat vector illustration,
clean modern Japanese mascot design, warm cream background (#FAF7F0),
high quality, centered composition, marketable IP character
--ar 1:1 --style raw --v 6
```

**日本語プロンプト（DALL·E / 日本語対応モデル用）:**
```
「ニャシェフ」という猫のシェフキャラクター、ちびキャラ2.5頭身、
クリーム色と白のふわふわ毛、耳先と尻尾先はこげ茶、琥珀色の目、
左耳が少し折れている、頬に小さな肉球マーク、ジト目でツンデレ感、
大きめの白いダブルブレストコックコート、袖まくり、
首にオレンジ（#FF8A3D）のバンダナ、コック帽なし、
木のしゃもじを持つ、フラットベクター風イラスト、
日本のマスコットキャラデザイン、温かいクリーム背景、
正方形、高クオリティ、商用利用可デザイン
```

### 6-2. 表情バリエーション用差分プロンプト

ベースプロンプトに以下を追加:

| 表情 | 追加キーワード |
|---|---|
| 提案1回目 | `one paw presenting a dish, proud smirk, confident expression` |
| 提案3回目 | `rubbing fingers together in "money gesture", cheeky grin, one eye closed` |
| 警告 | `one paw raised in stop gesture, other paw open asking for coin, stern face` |
| 決定！ | `both paws up in cheer, sparkling eyes, happy smile, small stars around head` |
| サブスク | `winking, thumbs up, holding infinity sign, cheerful expression` |
| 諦め | `sighing, closed eyes, ears drooping, slightly sad` |

### 6-3. Stable Diffusion 用（SDXL）

```
Positive: chibi cat chef mascot, 2.5 head proportion, cream white fur,
dark brown ear tips, amber eyes, folded left ear, paw-pad cheek marks,
oversized white chef coat, rolled sleeves, orange bandana,
no chef hat, holding rice scoop, tsundere half-lidded eyes,
flat vector illustration, modern Japanese mascot design,
cream background, clean lines, marketable character design

Negative: blurry, low quality, realistic, photorealistic, scary,
creepy, multiple characters, text, watermark, signature,
extra limbs, deformed, distorted proportions, human face, human hands,
adult content, dark mood, horror
```

### 6-4. 具体的な活用フロー

1. まず **ニュートラル表情（#1）** を上のプロンプトで 4〜8 枚生成、方向性を固める
2. 気に入った1枚をリファレンスにして、他 8 表情を `character reference` / `--cref`（MJ）や `IP-Adapter`（SD）で一貫性を保って生成
3. 背景透過化（Photoshop / remove.bg / rembg）
4. 2x, 3x 解像度で書き出し、Xcode Asset Catalog に登録
5. SNS 用は別背景で書き出し

---

## 7. 商用利用/権利の注意

- **生成 AI 使用時は各サービスの規約を確認**
  - Midjourney: 有料プランで商用利用可
  - DALL·E (via ChatGPT Plus): 商用利用可（2024 以降）
  - Stable Diffusion (ローカル / Hugging Face): モデルライセンスを確認
- 他キャラの著作権を侵害しない（既存マスコット風プロンプトは避ける）
- SNS 展開時は必ず透かしで `© Meshimase` を入れる

---

## 8. Do's / Don'ts

### ✅ Do
- 表情は常に **親しみやすく、少し意地悪**
- 料理の小物（しゃもじ、お玉、フライパン）を活用して動きを出す
- バンダナはブランド統一のため必ず着用

### ❌ Don't
- 人型に寄せすぎる（猫らしさを残す）
- グロテスクな表現・過度にリアル
- コック帽をかぶせる（他のキャラとの差別化ポイント）
- オレンジ以外のバンダナ色（ブランド識別性のため）

---

## 9. 次のアクション

1. 本書の方向性を確認・合意
2. Midjourney / DALL·E でニュートラル表情 (#1) を試作生成
3. OKが出たら 9 表情を一貫性保って生成
4. Xcode Asset Catalog へ登録 → アプリ内の `Image("nyashef_xxx")` 参照を復活
5. App Store アイコンも #1 ベースで作成
6. SNS アカウント開設（X / Instagram）時にヘッダー・アイコン差し替え
