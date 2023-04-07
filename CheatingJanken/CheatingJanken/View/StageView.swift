//
//  StageView.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/03/19.
//

import SwiftUI

struct StageView: View {
    @State private var gameStage: StageSituation? = nil
    @ObservedObject var stageViewModel = StageViewModel()
    
    var body: some View {
        VStack {
            Text("ステージを選択")
                .font(.largeTitle)
                .bold()
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, maxHeight: 80)
                .background(Color("ground"))
            
            ScrollView {
                VStack {
                    ForEach(stageViewModel.stageSituations, id: \.self) { stage in
                        Button {
                            gameStage = stage
                        } label: {
                            HStack {
                                Image(systemName: stage.situation ? "checkmark.shield.fill" : "checkmark.shield")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(Color.white)
                                    .frame(width: 30)
                                    .aspectRatio(contentMode: .fill)
                                Text("\(stage.stage)   \(stage.winRate) %")
                                    .font(.title)
                                    .foregroundColor(Color.white)
                                Spacer()
                            }
                            .padding()
                            .frame(width: 300, height: 80)
                            .background(Color("ground"))
                        }
                    }
                    .cornerRadius(20)
                    .padding(10)
                }
                .fullScreenCover(item: $gameStage, content: { gameStage in
                    HandGestureView(gameStage: gameStage)
                })
            }
        }
        .background(Color("background"))
    }
}

struct StageView_Previews: PreviewProvider {
    static var previews: some View {
        StageView()
    }
}
