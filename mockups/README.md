# 画面モックアップ

`index.html` をブラウザで開くと、Meshimase の6画面を iPhone フレーム風にプレビューできます。

## 開き方

### A. PC で見る
`mockups/index.html` をダブルクリック → 既定ブラウザで開く。
横並び6枚のグリッドで表示されます。

### B. スマホで見る（横スワイプ）
スマホ画面では **横スワイプで画面を切り替える** カルーセル形式になります。

#### 方法1: ファイルをスマホに送って開く
- Mac → iPhone: AirDrop で `index.html` を送る → Files アプリから開く
- それ以外: Slack / メールで自分宛に送る → リンクをタップ

#### 方法2: htmlpreview.github.io 経由でURL化（リポジトリがpublicの場合）
ブランチがリモートにある状態で、以下のURLをスマホで開く:
```
https://htmlpreview.github.io/?https://raw.githubusercontent.com/fvt0/test/claude/meal-suggestion-app-3Wg3U/mockups/index.html
```

#### 方法3: GitHub Pages を有効化
リポジトリ Settings → Pages で以下のように設定:
- Source: `Deploy from a branch`
- Branch: `claude/meal-suggestion-app-3Wg3U` / `/mockups`（or `/ (root)`）

しばらくすると `https://fvt0.github.io/test/` で公開されます。

### C. ローカルで軽量 HTTP サーバーを立てる（開発者向け）
```
cd mockups
python3 -m http.server 8000
# → http://localhost:8000 を開く
# 同じ Wi-Fi 内のスマホから http://<PCのIP>:8000 でも見られる
```

## 含まれる画面
1. オンボーディング（4/4 ページ）
2. ホーム / 気分選択
3. 提案カード（1回目）
4. 提案カード（3回目）+ 事前警告ダイアログ
5. Paywall（サブスク加入）
6. お店リスト（決定後）
