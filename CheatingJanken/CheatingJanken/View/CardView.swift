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
                .frame(width: 400, height: 100)
                .foregroundColor(.white.opacity(0.2))
                .cornerRadius(20)

            // MARK: - 研究用
            Text("タスク\(stageSituation.level)")
                .font(.system(size: 45))
                .bold()

            //            HStack {
            //                VStack {
            //                    // キャラクターを配置
            //                    Image(systemName: "person.fill")
            //                        .resizable()
            //                        .scaledToFit()
            //                        .frame(width: 140, height: 140)
            //                        .shadow(color: .black.opacity(0.4), radius: 10, x: 10, y: 10)
            //                }
            //
            //                Spacer()
            //                    .frame(width: 70)
            //
            //                // プログレスバー
            //                CircularProgressBarView(progress: CGFloat(stageSituation.level)*14.28/100)
            //                    .frame(width: 100, height: 100)
            //            }
        }

    }
}

struct SelectCardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(stageSituation: StageSituation(imageName: "007", level: 7, beforeWinRate: 30, userReversalWin: nil, userReversalLose: 0.2))
    }
}
