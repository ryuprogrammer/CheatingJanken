//
//  HealthPointView.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/04/11.
//

import SwiftUI

struct HealthPointView: View {
    @Binding var healthPoint: Double
    @Binding var healthColor: [Color]
    var body: some View {
        ZStack {
            Capsule()
                .fill(LinearGradient(gradient: Gradient(colors: [.black.opacity(0.5), .gray, .gray]),
                                     startPoint: .topLeading,
                                     endPoint: .bottomTrailing))
                .frame(width: 300, height: 23)
                .shadow(color: Color.white.opacity(0.5), radius: 20)
            VStack {
                Capsule()
                    .fill(LinearGradient(gradient: Gradient(colors: healthColor),
                                         startPoint: .topLeading,
                                         endPoint: .bottomTrailing))
                    .frame(width: 300*CGFloat(healthPoint/1000), height: 23)
                    .shadow(color: Color.white.opacity(0.2), radius: 3)
                    .padding(EdgeInsets(top: .zero, leading: .zero, bottom: .zero, trailing: 300*(1-CGFloat(healthPoint/1000))))
            }
        }
    }
}
