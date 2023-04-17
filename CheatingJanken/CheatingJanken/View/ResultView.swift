//
//  ResultView.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/04/11.
//

import SwiftUI

struct ResultView: View {
    // 環境変数を利用して画面を戻る
    @Environment(\.dismiss) private var dissmiss
    @Binding var finalResult: String?
    @Binding var gameStage: StageSituation
    @State private var offset = CGFloat.zero
    // アニメーション
    @State private var isAnimate: Bool = false
    var body: some View {
        ZStack {
            // 背景View
            BackgroundView(offset: $offset)

            VStack {
                HStack {
                    Button {
                        dissmiss()
                    } label: {
                        Text("もどる")
                            .bold()
                            .font(.system(size: 30))
                            .foregroundColor(Color.white)
                            .padding()
                            .frame(width: 120, height: 40)
                            .background(Color.white.opacity(0.3))
                            .cornerRadius(20)
                    }

                    Spacer()
                        .frame(width: 220)
                }

                Spacer()

                ZStack {
                    if let finalResult = finalResult {
                        Text(finalResult)
                            .foregroundColor(.pink)
                            .font(.system(size: isAnimate ? 50 : 65))
                            .bold()
                            .frame(width: 450, height: 80)
                            .blur(radius: 1)

                        Text(finalResult)
                            .foregroundColor(.pink)
                            .font(.system(size: 50))
                            .bold()
                            .frame(width: 450, height: 80)
                            .shadow(color: .blue, radius: 20, x: -20, y: -20)
                            .shadow(color: .mint, radius: 20, x: 20, y: 20)
                    }
                }

                Image(gameStage.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 400)
                    .shadow(color: .black.opacity(0.4), radius: 20, x: isAnimate ? -20 : 20, y: isAnimate ? -20 : 20)
                    .shadow(color: .white.opacity(0.5), radius: 20, x: isAnimate ? 20 : -20, y: isAnimate ? 20 : -20)

                Spacer()
            }
            .onAppear {
                withAnimation {
                    isAnimate = true
                }
            }
        }
    }
}
