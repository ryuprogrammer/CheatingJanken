//
//  GameView.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/03/19.
//

import SwiftUI

struct GameView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            VStack {
                Color("sky")
                Color("ground")
            }
            .ignoresSafeArea()
            
            Image("robot")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()
            
            VStack(spacing: 50) {
                Text("あいこ")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color("button"))
                    .frame(maxWidth: .infinity, maxHeight: 80)
                    .background(Color("theme").opacity(0.8))
                
                Image(systemName: "hand.wave.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .padding(30)
                    .background(Color.green.opacity(0.6))
                    .cornerRadius(70)
                    .frame(width: 190)
                    .offset(x: -90)

                Spacer()
                ZStack {
                    Image(systemName: "hand.wave.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .padding(30)
                        .background(Color.green.opacity(0.6))
                        .cornerRadius(70)
                        .frame(width: 220)
                    Text("あなた")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color.green)
                        .frame(width: 100, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                        .offset(y: -110)
                }
                
                Button {
                    dismiss()
                } label: {
                    Text("戻る")
                }
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
