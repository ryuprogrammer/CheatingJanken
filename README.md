# 『逆転じゃんけん』
<img width="600" src="https://github.com/ryuprogrammer/CheatingJanken_ryu/assets/120238831/e40d4ec3-76d8-4aa7-ba82-b8cd7836214b">

## 1. 概要・コンセプト
<img width="600" src="https://github.com/CodeCandySchool/CheatingJanken_ryu/assets/120238831/9683c83d-504b-4e5b-b1ab-b462d6a50f1a">

## 2. アプリの画面２つ
<img width="600" src="https://github.com/CodeCandySchool/CheatingJanken_ryu/assets/120238831/5c9ef1f4-230d-4a37-a0bd-39881b060d5f">
<img width="600" src="https://github.com/CodeCandySchool/CheatingJanken_ryu/assets/120238831/12db335f-02b9-4023-984c-28a015a007a7">

## 3. アプリの動作（Gif）
ユーザーの手を認識してじゃんけんをします。

<img width="200" src="https://github.com/CodeCandySchool/CheatingJanken_ryu/assets/120238831/0c1dfdc9-77c1-42a0-93f0-768953fe6f4f">

##  4. ダウンロードリンク
[![App_Store_Badge_JP](https://user-images.githubusercontent.com/68992872/204145956-f5cc0fa8-d4c9-4f2c-b1d4-3c3b1d2e2aba.png)](https://apps.apple.com/jp/app/%E9%80%86%E8%BB%A2%E3%81%98%E3%82%83%E3%82%93%E3%81%91%E3%82%93/id6448696945)

## 5. 今後の改善予定
今後は手の認識の速度を向上させます。

## 6. アプリの設計について

## 7. MVVMの構成図
## View
| ファイル名 | 概要・解説 |
| ---- | ---- |
| StageView | キャラクターと難易度をScrolleViewで表示するViewです。 |
| HandGestureView | 手を検知してじゃんけんをするViewです。 |
| ResultView | じゃんけんの結果を表示するViewです。 |
| BackgroundView | StageViewの背景のViewです。GeometryReaderを用いてスクロールに応じて背景が動きます。 |

## ViewModel
| ファイル名 | 概要・解説 |
| ---- | ---- |
| StageViewModel | StageModelのインスタンス、ボタンを押した時の効果音メソッドを記述したクラス |
| HandGestureViewModel | 勝率からゲーム結果を算出するメソッドや動画フレームから手のジェスチャーを検出するメソッドなどを記述したクラス |

## Model
| ファイル名 | 概要・解説 |
| ---- | ---- |
| StageModel | キャラクターのレベルや初期勝率、逆転の有無などの情報を格納した構造体 |
| SoundPlayer | 効果音を再生するメソッドなどを記述したクラス |
| JankenTextModel | じゃんけんの掛け声とタイミングのメソッドを記述したクラス |
| HandGestureModel | ゲーム終了を判定するメソッド、HPを計算するメソッドなどを記述したクラス |
| HandGestureDetector | 動画フレームからVisionを用いてジェスチャーを判別するメソッドなどを記述したクラス |

## 8. 工夫したコード／設計
### ポイント１　じゃんけんの手を判別
開発初期段階では、じゃんけんの手を3000枚撮影して、CreateMLを用いてモデルを作成して、CoreMLを用いて手を判別しました。しかし３度モデルを作り直しても判別の制度が良くならなかったのでVisionのみで手の判別をすることにしました。Visionでは、手の骨格の座標情報が取得できます。そこで、以下のような手順で手の判別を行うことで精度を向上させました。

・手順１：Visionを用いて指先、第二関節、手首の座標を取得
https://github.com/CodeCandySchool/CheatingJanken_ryu/blob/7743c188fa222dc87bd5faeda04d9fae7c5a0ed2/CheatingJanken/CheatingJanken/Model/HandGestureDetector.swift#L59-L70

・手順２：三平方の定理より２点の距離を求めるメソッド作成
https://github.com/CodeCandySchool/CheatingJanken_ryu/blob/7743c188fa222dc87bd5faeda04d9fae7c5a0ed2/CheatingJanken/CheatingJanken/Model/HandGestureDetector.swift#L112-L115

・手順３：手首から親指以外の指までの距離を求める
https://github.com/CodeCandySchool/CheatingJanken_ryu/blob/7743c188fa222dc87bd5faeda04d9fae7c5a0ed2/CheatingJanken/CheatingJanken/Model/HandGestureDetector.swift#L72-L82

・手順４：どの指が曲がっているかによってグーチョキパーを判別
https://github.com/CodeCandySchool/CheatingJanken_ryu/blob/7743c188fa222dc87bd5faeda04d9fae7c5a0ed2/CheatingJanken/CheatingJanken/Model/HandGestureDetector.swift#L84-L106

## 9 その他リンク
[ホームページ](https://f2v9l.hp.peraichi.com/cheatingjanken?_ga=2.91954137.299995805.1683264066-635457173.1683264066https://f2v9l.hp.peraichi.com/cheatingjanken?_ga=2.91954137.299995805.1683264066-635457173.1683264066)
[Twitter](https://twitter.com/engineerforios?s=11&t=E3_w-CiFaS5cBpi-By2fYg)

