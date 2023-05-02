//
//  StageView.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/03/19.
//

import SwiftUI

struct StageView: View {
    // StageViewModelのインスタンス生成
    @StateObject var stageViewModel = StageViewModel()
    // 選択されたgameStageを格納
    @State private var gameStage: StageSituation?
    // スクロールのoffsetを格納
    @State private var offset = CGFloat.zero

    var body: some View {
        ZStack {
            // 背景
            BackgroundView(offset: $offset)

            VStack {
                Text("ゲームメニュー")
                    .padding()
                    .bold()
                    .font(.system(size: 40))
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity)
                    .background(Color.mint.opacity(0.5))

                ScrollView {
                    VStack {
                        ForEach(stageViewModel.stageSituations, id: \.self) { stageSituation in
                            Button {
                                // タップしたステージデータをHandGestureViewに渡す
                                gameStage = stageSituation
                                // ボタンタップ音を再生
                                stageViewModel.playButtonSound()
                            } label: {
                                CardView(stageSituation: stageSituation)
                            }
                        }
                    }
                    .background(GeometryReader { proxy -> Color in
                        DispatchQueue.main.async {
                            offset = -proxy.frame(in: .named("scroll")).origin.y
                        }
                        return Color.clear
                    })
                    .fullScreenCover(item: $gameStage) { gameStage in
                        HandGestureView(gameStage: gameStage)
                    }
                }
            }
        }
    }
}

struct StageView_Previews: PreviewProvider {
    static var previews: some View {
        StageView()
    }
}
