//
//  HandGestureTestView.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/04/03.
//

import SwiftUI

struct HandGestureView: View {
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
    
    @State var gameStage: StageSituation
    
    var body: some View {
        ZStack {
            CameraView(camera: camera)
                .ignoresSafeArea(.all)
            
            backgroundColor
                .opacity(0.3)
                .ignoresSafeArea(.all)
            
            VStack {
                Spacer()
                    .frame(height: 100)
                
                Text("勝率：\(gameStage.winRate) %")
                    .bold()
                    .font(.system(size: 30))
                    .foregroundColor(Color.white)
                
                Text("あいて：\(gameStage.stage)")
                    .bold()
                    .font(.system(size: 30))
                    .foregroundColor(Color.white)
                // 敵のジャンケン結果
                if isShowEnemy {
                    Text("\(camera.handGestureModel.enemyHandGesture.rawValue)")
                        .bold()
                        .font(.system(size: 150))
                        .foregroundColor(Color.white)
                    
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
                
                Text("\(camera.handGestureDetector.currentGesture.rawValue)")
                    .bold()
                    .font(.system(size: 100))
                    .foregroundColor(Color.white)
                
                Text("あなた")
                    .bold()
                    .font(.system(size: 30))
                    .foregroundColor(Color.white)
                
                Spacer()
                    .frame(height: 100)
                
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
        }
        // timerを監視して
        .onReceive(timer) { _ in
            jankenCount += 1
            if jankenCount >= 20 {
                camera.stop()
                // ジャンケンの結果を出力
                camera.handGestureModel.JankenResult(userHandGesture: HandGestureDetector.HandGesture(rawValue: camera.handGestureDetector.currentGesture.rawValue) ?? .unknown, winRate: gameStage.winRate)
                isShowEnemy = true
                isCamera = false
                timer.upstream.connect().cancel()
            }
        }
        // currentGestureに応じて背景色を変化させる
        .onChange(of: camera.handGestureDetector.currentGesture.rawValue) { currentGesture in
            withAnimation {
                backgroundColor = (currentGesture == "？？？" ? .red : .mint)
            }
        }
        .onChange(of: jankenCount) { jankenCount in
            // カウント毎にテキストを変更する
            switch jankenCount {
            case 0,4,8: jankenText = "Ready.   "
            case 1,5,9: jankenText = "Ready..  "
            case 2,6,10: jankenText = "Ready... "
            case 3,7,11: jankenText = "Ready...?"
            case 12,13: jankenText = "最初は、、"
            case 14,15: jankenText = "ぐー！"
            case 16,17: jankenText = "じゃんけん"
            case 18,19,20: jankenText = "ぽん！！！"
            default: break
            }
        }
    }
}
