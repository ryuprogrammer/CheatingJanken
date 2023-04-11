//
//  StageView.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/03/19.
//

import SwiftUI

struct StageView: View {
    // 選択されたgameStageを格納
    @State private var gameStage: StageSituation? = nil
    let stageViewModel = StageViewModel()
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
                        ForEach(stageViewModel.stageSituations, id: \.self) { stageSituations in
                            Button {
                                gameStage = stageSituations
                            } label: {
                                CardView(stageSituation: stageSituations)
                            }
                        }
                        .cornerRadius(20)
                    }
                    .background(GeometryReader { proxy -> Color in
                        DispatchQueue.main.async {
                            offset = -proxy.frame(in: .named("scroll")).origin.y
                        }
                        return Color.clear
                    })
                    .fullScreenCover(item: $gameStage, content: { gameStage in
                        HandGestureView(gameStage: gameStage)
                    })
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
