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
                
                ZStack {
                    Image(systemName: "hand.wave.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .padding(30)
                        .background(Color.green.opacity(0.6))
                        .cornerRadius(70)
                        .frame(width: 190)
                    .offset(x: -90)
                    
                    Text("ロボット")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color.green)
                        .frame(width: 130, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                        .offset(x: -90, y: -90)
                }

                Spacer()
                
                ZStack {
                    Image("camera")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(70)
                        .frame(width: 220, height: 300)
                    
                    Rectangle()
                        .foregroundColor(Color.green.opacity(0.3))
                        .cornerRadius(70)
                        .frame(width: 220, height: 300)
                    
                    Image(systemName: "hand.wave.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white.opacity(0.6))
                        .padding(30)
                        .cornerRadius(70)
                        .frame(width: 220, height: 300)
                    
                    Text("あなた：チョキ")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color.green)
                        .frame(width: 220, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                        .offset(y: -130)
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
