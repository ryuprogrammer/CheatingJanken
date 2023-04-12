//
//  CardView.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/04/11.
//

import SwiftUI

struct CardView: View {
    @State var stageSituation: StageSituation
    var body: some View {
        ZStack {
            Rectangle()
                .font(.system(size: 30))
                .frame(width: 400, height: 200)
                .foregroundColor(.white.opacity(0.2))
                .cornerRadius(20)

            HStack {
                VStack {
                    // キャラクターを配置
                    Image("\(stageSituation.imageName)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                        .shadow(color: .black.opacity(0.4), radius: 10, x: 10, y: 10)
                }

                Spacer()
                    .frame(width: 70)

                // プログレスバー
                CircularProgressBarView(progress: stageSituation.winRate)
                    .frame(width: 100, height: 100)
            }
        }
    }
}

struct SelectCardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(stageSituation: StageSituation(imageName: "001", winRate: 0.8))
    }
}
