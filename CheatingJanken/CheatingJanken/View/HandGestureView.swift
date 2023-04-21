//
//  HandGestureTestView.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/04/03.
//

import SwiftUI
import AVFoundation

struct HandGestureView: View {
    // MARK: - インスタンス生成
    // HandGestureViewModelのインスタンス生成
    @ObservedObject private var camera = HandGestureViewModel()
    // JankenTextViewModelのインスタンス生成
    private let jankenTextViewModel = JankenTextViewModel()
    // MARK: - ゲーム関連
    // ジャンケンのカウントダウン用プロパティ
    @State private var jankenCount: Int = 0
    // ゲームの勝敗を格納
    @State private var finalResult: String?
    // 勝率を格納
    @State private var showWinRate: Int?
    // １回のジャンケンの終了判定
    @State private var isEndJanken: Bool = false
    // MARK: - 敵キャラの情報関連
    // 敵のHPを格納
    @State private var enemyHealthPoint: Double = 1000
    // 敵のHPの背景色を格納
    @State private var enemyHealthColor: [Color] = [.mint, .blue, .blue]
    // MARK: - ユーザーの情報関連
    // ユーザーのHPを格納
    @State private var userHealthPoint: Double = 1000
    // ユーザーのHPの背景色を格納
    @State private var userHealthColor: [Color] = [.mint, .blue, .blue]
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
    // 様々なデバイスの画面の大きさにリサイズするための値（iPhone14 ProMaxの縦横サイズ）
    let iPhone14ProMaxSizeWidth: Double = 430
    let iPhone14ProMaxSizeHeight: Double = 932
    // ユーザーのデバイスの画面の大きさ
    let UserScreenWidth: Double = UIScreen.main.bounds.size.width
    let UserScreenHeight: Double = UIScreen.main.bounds.size.height

    var body: some View {
        ZStack {
            CameraView(camera: camera)
                .ignoresSafeArea(.all)
                .onAppear {
                    camera.start()
                }
                .onDisappear {
                    camera.stop()
                }

            // 画面の大きさに合わせて画面の縁に色をつける
            RoundedRectangle(cornerRadius: 60)
                .stroke(backgroundColor.opacity(0.5), lineWidth: 50)
                .edgesIgnoringSafeArea(.all)
                .frame(width: UserScreenWidth, height: UserScreenHeight)

            VStack {
                Button {
                    dissmiss()
                } label: {
                    Text("もどる")
                        .bold()
                        .font(.system(size: 30))
                        .foregroundColor(Color.white)
                        .padding()
                        .frame(width: 120, height: 40)
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(20)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 40)

                // 勝率を表示
                Text("勝率：\(camera.handGestureModel.newWinRate ?? gameStage.winRate) %")
                    .bold()
                    .font(.system(size: 30))
                    .foregroundColor(Color.white)
                    .shadow(color: .black.opacity(0.4), radius: 5, x: 5, y: 5)

                HStack {
                    if isEndJanken {
                        // キャラクターのジャンケン結果を表示
                        Text("\(camera.handGestureModel.enemyHandGesture.rawValue)")
                            .bold()
                            .font(.system(size: 50))
                            .foregroundColor(Color.white)
                            .rotationEffect(Angle(degrees: -30))
                            .shadow(color: .black.opacity(0.4), radius: 5, x: 5, y: 5)
                    }

                    // キャラクターを配置
                    Image("\(gameStage.imageName)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                }

                // 敵のHPを表示
                HealthPointView(healthPoint: $enemyHealthPoint,
                                healthColor: $enemyHealthColor)

                if isEndJanken {
                    // ジャンケン結果を表示
                    Text("\(camera.handGestureModel.result.rawValue)")
                        .bold()
                        .font(.system(size: 100))
                        .foregroundColor(Color.white)
                        .shadow(color: .black.opacity(0.4), radius: 5, x: 5, y: 5)
                } else {
                    // ジャンケンのカウントダウンテキスト
                    Text(jankenTextViewModel.jankenText)
                        .bold()
                        .font(.system(size: 80))
                        .foregroundColor(Color.white)
                        .shadow(color: .black.opacity(0.4), radius: 5, x: 5, y: 5)
                }

                // ユーザーのHandPoseを表示
                Text("\(camera.handGestureDetector.currentGesture.rawValue)")
                    .bold()
                    .font(.system(size: 100))
                    .foregroundColor(Color.white)
                    .rotation3DEffect(Angle(degrees: 180), axis: (x: 0, y: 1, z: 0))
                    .shadow(color: .black.opacity(0.4), radius: 5, x: 5, y: 5)

                Text("あなた")
                    .bold()
                    .font(.system(size: 30))
                    .foregroundColor(Color.white)
                    .shadow(color: .black.opacity(0.4), radius: 5, x: 5, y: 5)

                // ユーザーのHPを表示
                HealthPointView(healthPoint: $userHealthPoint,
                                healthColor: $userHealthColor)

                // ゲーム再開ボタン
                if isEndJanken {
                    Button {
                        // カメラを再開
                        camera.start()
                        // 次のジャンケンを開始
                        isEndJanken = false
                    } label: {
                        Text("次へ")
                            .bold()
                            .font(.system(size: 50))
                            .foregroundColor(Color.white)
                            .padding()
                            .frame(width: 230, height: 85)
                            .background(Color.white.opacity(0.3))
                            .cornerRadius(20)
                    }
                } else {
                    Spacer()
                        .frame(height: 155)
                }
            }
            .ignoresSafeArea(.all)
            .frame(width: UserScreenWidth, height: UserScreenHeight)
            // 各デバイスの画面の大きさに合わせる
            .scaleEffect(CGSize(width: min(1, UserScreenWidth/iPhone14ProMaxSizeWidth),
                                height: min(1, UserScreenHeight/iPhone14ProMaxSizeHeight)),
                         anchor: UnitPoint.center)
            .fullScreenCover(isPresented: $isShowResultView, onDismiss: {
                dissmiss()
            }) {
                ResultView(finalResult: $finalResult, gameStage: $gameStage)
            }
        }
        .onReceive(camera.jankenCallTimer, perform: { _ in
            jankenCount += 1
            let jankenFinishTime: Int = 7
            if jankenCount >= jankenFinishTime {
                camera.stop()
                // ジャンケンの結果を出力
                camera.handGestureModel.JankenResult(userHandGesture: HandGestureDetector.HandGesture(
                                                        rawValue: camera.handGestureDetector.currentGesture.rawValue) ?? .unknown, stageSituation: gameStage)
                withAnimation {
                    // HPをアニメーションで変化させる
                    enemyHealthPoint = camera.handGestureModel.enemyHealthPoint
                    userHealthPoint = camera.handGestureModel.userHealthPoint
                    enemyHealthColor = camera.handGestureModel.enemyHealthColor
                    userHealthColor = camera.handGestureModel.userHealthColor
                }
                // ゲーム終了を判定
                finalResult = camera.handGestureModel.judgeWinner(enemyHealthPoint: enemyHealthPoint, userHealthPoint: userHealthPoint)

                if let _ = finalResult {
                    isShowResultView = true
                }
                // １回のジャンケンを終了
                isEndJanken = true
                // 掛け声をリセット
                jankenCount = 0
            }
        })
        // currentGestureが適切に判定されているか確認
        .onChange(of: camera.handGestureDetector.currentGesture.rawValue) { currentGesture in
            withAnimation {
                backgroundColor = (currentGesture == "？？？" ? .red : .mint)
            }
        }
        .onChange(of: jankenCount) { jankenCount in
            // カウント毎にテキストを更新する
            jankenTextViewModel.makeJankenText(jankenCount: jankenCount)
        }
    }
}
