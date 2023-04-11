//
//  BackgroundView.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/04/11.
//

import SwiftUI

struct BackgroundView: View {
    // スクロールのoffsetを格納
    @Binding var offset: CGFloat
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color.mint.opacity(0.3))
                .blur(radius: 50)
                .frame(width: 900)
                .position(CGPoint(x: 400, y: 800-offset*0.5))
            
            Circle()
                .foregroundColor(Color.blue.opacity(0.5))
                .blur(radius: 50)
                .frame(width: 500 - offset*0.3)
                .position(CGPoint(x: 0, y: 500+offset*0.5))
            
            Circle()
                .foregroundColor(Color.red.opacity(0.5))
                .blur(radius: 50)
                .position(CGPoint(x: 300, y: 0))
                .rotationEffect(Angle(degrees: -offset*0.01), anchor: UnitPoint(x: 0, y: 1.5))
        }
    }
}
