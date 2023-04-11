//
//  HandGestureTestView.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/04/03.
//

import SwiftUI

struct HandGestureView: View {
    // 環境変数を利用して画面を戻る
    @Environment(\.dismiss) var dissmiss
    // HandGestureViewModelのインスタンス生成
    @ObservedObject private var camera = HandGestureViewModel()
    // Viewの背景色のプロパティ
    @State private var backgroundColor = Color.red
    // カメラのオンオフを切り替えるプロパティ
    @State private var isCamera = false
    // ジャンケンのカウントダウン用プロパティ
    @State private var jankenCount: Int = 0
    // 決められた時間毎にイベントを発行
    @State private var timer = Timer.publish(every: 0.35, on: .main, in: .common).autoconnect()
    // ジャンケンの掛け声
    @State private var jankenText: String = ""
    // 敵のジャンケン結果の表示有無
    @State private var isShowEnemy: Bool = false
    // StageViewから選択されたStageSituationを格納
    @State var gameStage: StageSituation
    // 敵のHPを格納
    @State var enemyHealthPoint: Double = 1000
    // ユーザーのHPを格納
    @State var userHealthPoint: Double = 1000
    // 敵のHPの背景色を格納
    @State var enemyHealthColor: [Color] = [.mint, .blue, .blue]
    // ユーザーのHPの背景色を格納
    @State var userHealthColor: [Color] = [.mint, .blue, .blue]
    // ゲームの勝敗を格納
    @State var finalResult: String? = nil
    // ResultViewの表示有無
    @State var isShowResultView: Bool = false
    
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
                
                HStack {
                    if isShowEnemy {
                        // キャラクターのジャンケン結果を表示
                        Text("\(camera.handGestureModel.enemyHandGesture.rawValue)")
                            .bold()
                            .font(.system(size: 50))
                            .foregroundColor(Color.white)
                            .rotationEffect(Angle(degrees: -30))
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
                } else {
                    // ジャンケンのカウントダウン
                    Text(jankenText)
                        .bold()
                        .font(.system(size: 80))
                        .foregroundColor(Color.white)
                }
                
                // ユーザーのHandPoseを表示
                Text("\(camera.handGestureDetector.currentGesture.rawValue)")
                    .bold()
                    .font(.system(size: 100))
                    .foregroundColor(Color.white)
                    .rotation3DEffect(Angle(degrees: 180), axis: (x: 0, y: 1, z: 0))
                
                Text("あなた")
                    .bold()
                    .font(.system(size: 30))
                    .foregroundColor(Color.white)
                
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
                        timer = Timer.publish(every: 0.35, on: .main, in: .common).autoconnect()
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
        // timerを監視して
        .onReceive(timer) { _ in
            jankenCount += 1
            if jankenCount >= 11 {
                camera.stop()
                // ジャンケンの結果を出力
                camera.handGestureModel.JankenResult(userHandGesture: HandGestureDetector.HandGesture(
                    rawValue: camera.handGestureDetector.currentGesture.rawValue) ?? .unknown, winRate: Int(gameStage.winRate))
                withAnimation {
                    enemyHealthPoint = camera.handGestureModel.enemyHealthPoint
                    userHealthPoint = camera.handGestureModel.userHealthPoint
                    enemyHealthColor = camera.handGestureModel.enemyHealthColor
                    userHealthColor = camera.handGestureModel.userHealthColor
                }
                print(enemyHealthPoint)
                print(camera.handGestureModel.enemyHealthPoint)
                
                // ゲーム終了を判定
                finalResult = camera.handGestureModel.judgeWinner(enemyHealthPoint: enemyHealthPoint, userHealthPoint: userHealthPoint)
                
                if finalResult != nil {
                    isShowResultView = true
                }
                
                isShowEnemy = true
                isCamera = false
                timer.upstream.connect().cancel()
            }
        }
        // currentGestureが適切に判定されているか確認
        .onChange(of: camera.handGestureDetector.currentGesture.rawValue) { currentGesture in
            withAnimation {
                backgroundColor = (currentGesture == "？？？" ? .red : .mint)
            }
        }
        .onChange(of: jankenCount) { jankenCount in
            // カウント毎にテキストを変更する
            switch jankenCount {
            case 0,1,2: jankenText = "Ready.   "
            case 3,4: jankenText = "最初は、、"
            case 5,6: jankenText = "ぐー！"
            case 7,8: jankenText = "じゃんけん"
            case 9,10,11: jankenText = "ぽん！！！"
            default: break
            }
        }
    }
}
