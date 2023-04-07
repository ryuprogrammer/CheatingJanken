//
//  HandGestureTestView.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/04/03.
//

import SwiftUI

struct HandGestureView: View {
    // CameraModelのインスタンス生成
    @ObservedObject var camera = CameraModel()
    // JankenGameのインスタンス生成
    @StateObject var jankenGame = JankenGameModel()
    // Viewの背景色のプロパティ
    @State private var backgroundColor = Color.red
    // カメラのオンオフを切り替えるプロパティ
    @State private var isCamera = false
    // ジャンケンのカウントダウン用プロパティ
    @State private var jankenCount: Int = 0
    // 決められた時間毎にイベントを発行
    @State private var timer = Timer.publish(every: 0.7, on: .main, in: .common).autoconnect()
    // ジャンケンの掛け声
    @State private var jankenText: String = ""
    // 敵のジャンケン結果の表示有無
    @State private var isShowEnemy: Bool = false
    
    var body: some View {
        ZStack {
            CameraView(camera: camera)
                .ignoresSafeArea(.all)
            
            backgroundColor
                .opacity(0.3)
                .ignoresSafeArea(.all)
            
            VStack {
                // 敵のジャンケン結果
                if isShowEnemy {
                    Text("てき")
                        .bold()
                        .font(.system(size: 30))
                        .foregroundColor(Color.white)
                    
                    Text("\(jankenGame.enemyHandGesture.rawValue)")
                        .bold()
                        .font(.system(size: 150))
                        .foregroundColor(Color.white)
                    
                    Text("\(jankenGame.result.rawValue)")
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
                    .frame(height: 200)
                
                // カメラのオンオフの切り替え
                Button {
                    if isCamera {
                        camera.stop()
                    } else {
                        isShowEnemy = false
                        jankenCount = 0
                        timer = Timer.publish(every: 0.7, on: .main, in: .common).autoconnect()
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
            if jankenCount >= 8 {
                camera.stop()
                // ジャンケンの結果を出力
                jankenGame.JankenResult(userHandGesture: HandGestureDetector.HandGesture(rawValue: camera.handGestureDetector.currentGesture.rawValue) ?? .unknown)
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
            case 0...3: jankenText = "Ready ???"
            case 4: jankenText = "最初は、、"
            case 5: jankenText = "ぐー！"
            case 6: jankenText = "じゃんけん"
            case 7,8: jankenText = "ぽん！！！"
            default: break
            }
        }
    }
}

struct HandGestureView_Previews: PreviewProvider {
    static var previews: some View {
        HandGestureView()
    }
}
