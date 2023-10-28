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
                .frame(width: 400, height: 400)
                .foregroundColor(.white.opacity(0.2))
                .cornerRadius(20)

            // MARK: - 研究用
            Text("タスク\(stageSituation.level)")
                .font(.system(size: 45))
                .bold()
        }

    }
}

struct SelectCardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(stageSituation: StageSituation(imageName: "007", level: 7, winRate: 30, userReversalWin: nil, userReversalLose: 0.2))
    }
}
