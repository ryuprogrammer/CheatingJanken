import SwiftUI
import AVFoundation

struct HandGestureView: View {
    // MARK: - インスタンス生成
    // HandGestureViewModelのインスタンス生成
    @StateObject private var handGestureViewModel = HandGestureViewModel()
    // MARK: - ゲーム関連
    // ジャンケンのカウントダウン用プロパティ
    @State private var jankenCount: Int = 0
    // ゲームの勝敗を格納
    @State private var finalResult: String?
    // 勝率を格納
    @State private var showWinRate: Int?
    // １回のジャンケンの終了判定
    @State private var isEndJanken: Bool = false
    // MARK: - 画面遷移
    // 環境変数を利用して画面を戻る
    @Environment(\.dismiss) private var dissmiss
    // StageViewから選択されたStageSituationを格納
    @State var gameStage: StageSituation
    // ResultViewの表示有無
    @State private var isShowResultView: Bool = false
    // MARK: - 画面、背景
    // Viewの背景色のプロパティ（ジャンケンの手が有効の時青、無効の時赤に変化）
    @State private var backgroundColor = Color.red
    // ユーザーのデバイスの画面の大きさ
    private let userScreenWidth: Double = UIScreen.main.bounds.size.width
    private let userScreenHeight: Double = UIScreen.main.bounds.size.height

    // MARK: - 研究用のプロパティ
    // タスク２つ分の回数
    @State private var gameCount: Int = 20
    // MARK: - カウントを添付
    // 味方の勝利数
    @State private var userWinCount: Int = 0
    // 敵の勝利数
    @State private var enemyWinCount: Int = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CameraView(camera: handGestureViewModel)
                    .ignoresSafeArea(.all)
                    .onAppear {
                        handGestureViewModel.start()
                    }
                    .onDisappear {
                        handGestureViewModel.stop()
                    }

                // 画面の大きさに合わせて画面の縁に色をつける
                RoundedRectangle(cornerRadius: 60)
                    .stroke(backgroundColor.opacity(0.5), lineWidth: 50)
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: userScreenWidth, height: userScreenHeight)

                VStack(spacing: 30) {
                    // 敵のView
                    enemyContentsView

                    // じゃんけんの結果
                    resultView

                    Spacer()
                        .frame(height: 180)
                }
                .ignoresSafeArea(.all)
                .frame(width: geometry.size.width, height: geometry.size.height)
                // 各デバイスの画面の大きさに合わせる
                .scaleEffect(CGSize(width: min(1, userScreenWidth/geometry.size.width),
                                    height: min(1, userScreenHeight/geometry.size.height)),
                             anchor: UnitPoint.center)
                .fullScreenCover(isPresented: $isShowResultView, onDismiss: {
                    dissmiss()
                }) {
                    ResultView(finalResult: $finalResult, gameStage: $gameStage)
                }

                // ボタン系
                VStack {
                    // 戻るボタン
                    returnButton

                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)

                // ユーザーのView
                userContentsView
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .onReceive(handGestureViewModel.jankenCallTimer, perform: { _ in
            jankenCount += 1
            let jankenFinishTime: Int = 25

            if jankenCount >= jankenFinishTime {
                // MARK: - 研究用
                if handGestureViewModel.isEndgame {
                    // ゲーム終了→画面遷移
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        // 画面遷移back
                        dissmiss()
                    }
                }

                // カメラを止める
                handGestureViewModel.stop()
                // ジャンケンの結果を出力
                handGestureViewModel.calculateJankenResult(stageSituation: gameStage)
                // ゲーム終了を判定
                finalResult = handGestureViewModel.judgeWinner()
                // １回のジャンケンを終了
                isEndJanken = true

                // 数秒後にじゃんけん再開させる→ここを長くしたくはない、、、
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    // カメラを再開
                    handGestureViewModel.start()
                    // 次のジャンケンを開始
                    isEndJanken = false
                    // ジャンケンの掛け声を元に戻す
                    jankenCount = 0
                }
            }
        })
        // currentGestureが適切に判定されているか確認
        .onChange(of: handGestureViewModel.currentGesture.rawValue) { currentGesture in
            withAnimation {
                backgroundColor = (currentGesture == "？？？" ? .red : .mint)
            }
        }
        .onChange(of: jankenCount) { jankenCount in
            // カウント毎にテキストを更新する
            handGestureViewModel.makeJankenText(jankenCount: jankenCount)
        }
    }

    @ViewBuilder
    private var enemyContentsView: some View {
        HStack {
            // キャラクターのジャンケン結果を表示
            Text(isEndJanken ? "\(handGestureViewModel.enemyHandGesture.rawValue)" : "✊")
                .bold()
                .font(.system(size: 120))
                .foregroundColor(Color.white)
                .rotationEffect(Angle(degrees: -30))
                .shadow(color: .black.opacity(0.4), radius: 5, x: 5, y: 5)

            // キャラクターを配置
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 100, height: 100)
                .shadow(color: .black.opacity(0.4), radius: 5, x: 5, y: 5)
        }
    }

    @ViewBuilder
    private var resultView: some View {
        VStack {
            HStack {
                VStack {
                    Spacer()
                        .frame(height: 40)
                    Text("あなた")
                        .bold()
                        .font(.system(size: 20))
                        .foregroundColor(Color.white)
                        .shadow(color: .black.opacity(0.4), radius: 5, x: 5, y: 5)
                }

                Spacer()
                    .frame(width: 80)
                //                // スコアの表示
                //                Text("\(handGestureViewModel.userWinCount) vs \(handGestureViewModel.enemyWinCount)")
                //                    .bold()
                //                    .font(.system(size: 80))
                //                    .foregroundColor(Color.white)
                //                    .shadow(color: .black.opacity(0.4), radius: 5, x: 5, y: 5)
                VStack {
                    Spacer()
                        .frame(height: 40)
                    Text("あいて")
                        .bold()
                        .font(.system(size: 20))
                        .foregroundColor(Color.white)
                        .shadow(color: .black.opacity(0.4), radius: 5, x: 5, y: 5)
                }
            }

            // MARK: - 研究用
            // カウント表示
            WinCountBarView(
                userWinCount: $handGestureViewModel.userWinCount, enemyWinCount: $handGestureViewModel.enemyWinCount
            )

            // ジャンケンのテキスト
            Text(isEndJanken ? handGestureViewModel.result.rawValue : handGestureViewModel.jankenText)
                .bold()
                .font(.system(size: 80))
                .foregroundColor(Color.white)
                .shadow(color: .black.opacity(0.4), radius: 5, x: 5, y: 5)
        }
    }

    @ViewBuilder
    private var returnButton: some View {
        Button {
            dissmiss()
        } label: {
            Text("もどる")
                .bold()
                .font(.system(size: 30))
                .foregroundColor(Color.white)
                .padding()
                .frame(width: 120, height: 40)
                .background(Color.cyan.opacity(0.5))
                .cornerRadius(20)
                .padding(.top, 20)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 40)
    }

    @ViewBuilder
    private var userContentsView: some View {
        // ユーザーのHandPoseを表示
        Text("\(handGestureViewModel.handGestureDetector.currentGesture.rawValue)")
            .bold()
            .font(.system(size: 200))
            .foregroundColor(Color.white)
            .rotation3DEffect(Angle(degrees: 180), axis: (x: 0, y: 1, z: 0))
            .shadow(color: .black.opacity(0.4), radius: 5, x: 5, y: 5)
            .position(
                x: userScreenWidth*1.1-handGestureViewModel.handGestureDetector.wristPosition.y*(userScreenWidth)*1.3,
                y: max(handGestureViewModel.handGestureDetector.wristPosition.x*userScreenHeight-100, 730)
            )
    }

    @ViewBuilder
    private var jankenButtonView: some View {
        // ゲーム再開ボタン
        Button {
            if isEndJanken {
                // カメラを再開
                handGestureViewModel.start()
                // 次のジャンケンを開始
                isEndJanken = false
                // ジャンケンの掛け声を元に戻す
                jankenCount = 0
            }
        } label: {
            Text("次へ")
                .bold()
                .font(.system(size: 50))
                .foregroundColor(isEndJanken ? Color.white : Color.clear)
                .padding()
                .frame(width: 230, height: 55)
                .background(isEndJanken ? Color.cyan.opacity(0.5) : Color.clear)
                .cornerRadius(20)
                .padding(.bottom, 20)
        }
    }
}
