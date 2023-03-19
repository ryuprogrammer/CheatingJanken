//
//  StageView.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/03/19.
//

import SwiftUI

struct StageView: View {
    @State var stage: [stageSituation] = [
        stageSituation(stage: "ネズミ", situation: true, pasentage: 80),
        stageSituation(stage: "うさぎ", situation: true, pasentage: 60),
        stageSituation(stage: "犬", situation: true, pasentage: 50),
        stageSituation(stage: "ぞう", situation: false, pasentage: 30),
        stageSituation(stage: "パンダ", situation: false, pasentage: 20),
        stageSituation(stage: "人間", situation: false, pasentage: 8),
        stageSituation(stage: "ロボット", situation: false, pasentage: 2)
    ]
    
    @State var gameStage: stageSituation? = nil
    
    var body: some View {
        VStack {
            Text("ステージを選択")
                .font(.largeTitle)
                .bold()
                .foregroundColor(Color("button"))
                .frame(maxWidth: .infinity, maxHeight: 80)
                .background(Color("theme"))
            
            ScrollView {
                VStack {
                    ForEach(stage) { stage in
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
                                Text("\(stage.stage)   \(stage.pasentage) %")
                                    .font(.title)
                                    .foregroundColor(Color.white)
                                Spacer()
                            }
                            .padding()
                            .frame(width: 300, height: 80)
                            .background(Color("theme"))
                        }
                    }
                    .cornerRadius(20)
                    .padding(10)
                }
                .fullScreenCover(item: $gameStage, content: { item in
                    GameView()
                })
            }
        }
        .background(Color("background"))
    }
}

struct stageSituation: Identifiable {
    let id: UUID = UUID()
    let stage: String
    let situation: Bool
    let pasentage: Int
}

struct StageView_Previews: PreviewProvider {
    static var previews: some View {
        StageView()
    }
}
