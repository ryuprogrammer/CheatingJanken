//
//  HandGestureTestView.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/04/03.
//

import SwiftUI

struct HandGestureView: View {
// MARK: - インスタンス生成
    // HandGestureViewModelのインスタンス生成
    @ObservedObject private var camera = HandGestureViewModel()
    // JankenTextViewModelのインスタンス生成
    let jankenTextViewModel = JankenTextViewModel()
// MARK: - ゲーム関連
    // ジャンケンのカウントダウン用プロパティ
    @State private var jankenCount: Int = 0
    // ジャンケンの掛け声
    @State private var jankenText: String = ""
    // ゲームの勝敗を格納
    @State var finalResult: String?
// MARK: - 敵キャラの情報関連
    // 敵のHPを格納
    @State var enemyHealthPoint: Double = 1000
    // 敵のHPの背景色を格納
    @State var enemyHealthColor: [Color] = [.mint, .blue, .blue]
    // 敵のジャンケン結果の表示有無
    @State private var isShowEnemy: Bool = false
// MARK: - ユーザーの情報関連
    // ユーザーのHPを格納
    @State var userHealthPoint: Double = 1000
    // ユーザーのHPの背景色を格納
    @State var userHealthColor: [Color] = [.mint, .blue, .blue]
// MARK: - 画面遷移
    // 環境変数を利用して画面を戻る
    @Environment(\.dismiss) var dissmiss
    // StageViewから選択されたStageSituationを格納
    @State var gameStage: StageSituation
    // ResultViewの表示有無
    @State var isShowResultView: Bool = false
// MARK: - カメラ
    // カメラのオンオフを切り替えるプロパティ
    @State private var isCamera = false
    // Viewの背景色のプロパティ（ジャンケンの手が有効の時青、無効の時赤に変化）
    @State private var backgroundColor = Color.red

    var body: some View {
        ZStack {
            CameraView(camera: camera)
                .ignoresSafeArea(.all)

            GeometryReader { geometry in
                // iPhoneの形状に合わせてmint色の縁を表示
                RoundedRectangle(cornerRadius: 60)
                    .stroke(backgroundColor.opacity(0.5), lineWidth: 50)
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }

            VStack {
                HStack {
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

                    Spacer()
                        .frame(width: 220)
                }

                Text("勝率：\(Int(gameStage.winRate*100)) %")
                    .bold()
                    .font(.system(size: 30))
                    .foregroundColor(Color.white)
                    .shadow(color: .black.opacity(0.4), radius: 5, x: 5, y: 5)

                HStack {
                    if isShowEnemy {
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

                if isShowEnemy {
                    // ジャンケン結果を表示
                    Text("\(camera.handGestureModel.result.rawValue)")
                        .bold()
                        .font(.system(size: 100))
                        .foregroundColor(Color.white)
                        .shadow(color: .black.opacity(0.4), radius: 5, x: 5, y: 5)
                } else {
                    // ジャンケンのカウントダウンテキスト
                    Text(jankenText)
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

                // カメラのオンオフの切り替え
                Button {
                    if isCamera {
                        camera.stop()
                    } else {
                        isShowEnemy = false
                        jankenCount = 0
                        camera.start()
                    }
                    isCamera.toggle()
                } label: {
                    Text(isCamera ? "ストップ" : "もう一回")
                        .bold()
                        .font(.system(size: 50))
                        .foregroundColor(Color.white)
                        .padding()
                        .frame(width: 230, height: 85)
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(20)
                }
            }
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
                                                        rawValue: camera.handGestureDetector.currentGesture.rawValue) ?? .unknown, winRate: Int(gameStage.winRate))
                // HPをアニメーションで変化させる
                withAnimation {
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

                isShowEnemy = true
                isCamera = false
            }
        })
        // currentGestureが適切に判定されているか確認
        .onChange(of: camera.handGestureDetector.currentGesture.rawValue) { currentGesture in
            withAnimation {
                backgroundColor = (currentGesture == "？？？" ? .red : .mint)
            }
        }
        .onChange(of: jankenCount) { jankenCount in
            // カウント毎にテキストを変更する
            jankenText = jankenTextViewModel.jankenText(jankenCount: jankenCount)
        }
    }
}
