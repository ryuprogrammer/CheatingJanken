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
↓ダウンロードリンクを画像に埋め込みたいが、方法がわからない。
[ダウンロードはこちら](https://apps.apple.com/jp/app/%E9%80%86%E8%BB%A2%E3%81%98%E3%82%83%E3%82%93%E3%81%91%E3%82%93/id6448696945)

## 5. リリース予定の内容
今後は手の認識の速度を向上させます。

## 6. アプリの設計について
## View
| ファイル名 | 概要・解説 |
| ---- | ---- |
| StageView | a |
| HandGestureView | a |
| ResultView | a |
| HealthPointView | s |
| BackgroundView | a |

## ViewModel
| ファイル名 | 概要・解説 |
| ---- | ---- |
| StageViewModel | a |
| HandGestureViewModel | a |

## Model
| ファイル名 | 概要・解説 |
| ---- | ---- |
| StageModel | a |
| SoundPlayer | a |

- フローチャート
こちらで[フローチャートについて学習をして](https://cacoo.com/ja/blog/keep-it-simple-how-to-avoid-overcomplicating-your-flowcharts/)、フローチャートを記述してみてください。
Miroでも、Keynoteでも、フリーボードでも作成しやすいツールで構わないです。

## 7. MVVMの構成図
参考情報の他の受講生のポートフォリオを参考にして、MVVMの構成図を作成してください。

## 8. 工夫したコード／設計
プロジェクトで工夫した設計や、コードを具体的に示してください。
該当コードを示して、どんな工夫をしたのか分かりやすく記載してください。
### ポイント１ タスクをタイムチャートで表示
タスクの開始時間と終了時間を可視化するためにタイムチャートを作成しました。
↓タイムチャート
<img width="200" src="https://github.com/CodeCandySchool/GoodPostureStudy_ryu/assets/120238831/c693b9d4-d165-4f24-8c86-bb3d8ed56e55">

https://github.com/CodeCandySchool/GoodPostureStudy_ryu/blob/031942d3ee0d5546858dbe470d83b084358d590a/GoodPostureStudy_ryu/GoodPostureStudy_ryu/View/ViewMaterial/CircularTimeBarView.swift#L27-L100

### ポイント２ 過去7日分のデータをChartで表示
CoreDataからタスクデータを取得して、完了済みのタスクの合計時間を過去7日分Chartで表示しました。
↓Chart
<img width="200" src="https://github.com/CodeCandySchool/GoodPostureStudy_ryu/assets/120238831/0d5ad873-1657-425a-9148-a3754e0ed612">

https://github.com/CodeCandySchool/GoodPostureStudy_ryu/blob/031942d3ee0d5546858dbe470d83b084358d590a/GoodPostureStudy_ryu/GoodPostureStudy_ryu/ViewModel/BarMarkViewModel.swift#L10-L127

## 9 その他リンク
[ホームページ](https://y70ns.hp.peraichi.com/posta)
[作成者Twitter](https://twitter.com/engineerforios?s=11&t=E3_w-CiFaS5cBpi-By2fYg)

