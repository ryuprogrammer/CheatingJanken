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
                    
                    // ユーザーのView
                    userContentsView
                    
                    Spacer()
                        .frame(height: 50)
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
                    
                    // ゲーム再開ボタン
                    jankenButtonView
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .onReceive(handGestureViewModel.jankenCallTimer, perform: { _ in
            jankenCount += 1
            let jankenFinishTime: Int = 25
            
            if jankenCount >= jankenFinishTime {
                // カメラを止める
                handGestureViewModel.stop()
                // ジャンケンの結果を出力
                handGestureViewModel.calculateJankenResult(stageSituation: gameStage)
                // ゲーム終了を判定
                finalResult = handGestureViewModel.judgeWinner()
                
                // 画面遷移させないのでコメントアウト
                //                if let _ = finalResult {
                //                    isShowResultView = true
                //                }
                //                // １回のジャンケンを終了
                //                isEndJanken = true
                
                // 数秒後にじゃんけん再開させる
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
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
                .font(.system(size: 70))
                .foregroundColor(Color.white)
                .rotationEffect(Angle(degrees: -30))
                .shadow(color: .black.opacity(0.4), radius: 5, x: 5, y: 5)
            
            // キャラクターを配置
            Image("\(gameStage.imageName)")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
        }
        
        // 敵のHPを表示
        HealthPointView(healthPoint: $handGestureViewModel.enemyHealthPoint,
                        healthColor: $handGestureViewModel.enemyHealthColor)
    }
    
    @ViewBuilder
    private var resultView: some View {
        // ジャンケンのテキスト
        Text(isEndJanken ? handGestureViewModel.result.rawValue : handGestureViewModel.jankenText)
            .bold()
            .font(.system(size: 80))
            .foregroundColor(Color.white)
            .shadow(color: .black.opacity(0.4), radius: 5, x: 5, y: 5)
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
            .font(.system(size: 130))
            .foregroundColor(Color.white)
            .rotation3DEffect(Angle(degrees: 180), axis: (x: 0, y: 1, z: 0))
            .shadow(color: .black.opacity(0.4), radius: 5, x: 5, y: 5)
        
        // ユーザーのHPを表示
        HealthPointView(healthPoint: $handGestureViewModel.userHealthPoint,
                        healthColor: $handGestureViewModel.userHealthColor)
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
