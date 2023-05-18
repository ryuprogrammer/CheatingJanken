# 『逆転じゃんけん』
<img width="600" src="https://github.com/CodeCandySchool/CheatingJanken_ryu/assets/120238831/e40d4ec3-76d8-4aa7-ba82-b8cd7836214b">

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

## 5. リリース予定の内容
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
| StageModel | a |
| SoundPlayer | a |
| JankenTextModel | a |
| StageSituation | a |
| HandGestureModel | a |
| HandGestureDetector | s |

## 8. 工夫したコード／設計

## 9 その他リンク
[ホームページ](https://f2v9l.hp.peraichi.com/cheatingjanken?_ga=2.91954137.299995805.1683264066-635457173.1683264066https://f2v9l.hp.peraichi.com/cheatingjanken?_ga=2.91954137.299995805.1683264066-635457173.1683264066)
[作成者Twitter](https://twitter.com/engineerforios?s=11&t=E3_w-CiFaS5cBpi-By2fYg)

