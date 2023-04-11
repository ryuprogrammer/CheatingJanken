//
//  CircularProgressBarView.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/04/11.
//

import SwiftUI

struct CircularProgressBarView: View {
    @State var progress: CGFloat
    @State var percentage: Int = 0
    @State var isProgress: Bool = false
    var body: some View {
        ZStack {
            // 背景の円
            Circle()
            // 円形の線描写するように指定
                .stroke(lineWidth: 12)
                .foregroundColor(.mint.opacity(0.15))
            
            // 進捗を示す円
            Circle()
                .trim(from: 0.0, to: min(isProgress ? progress : 0, 1.0))
                // 線の端の形状などを指定
                .stroke(style: StrokeStyle(lineWidth: 16, lineCap: .round, lineJoin: .round))
                .fill(LinearGradient(gradient: Gradient(colors: [.blue, .mint]),
                                     startPoint: .top,
                                     endPoint: .bottom))
                .rotationEffect(Angle(degrees: 270))
            
            VStack {
                Text("勝率")
                    .font(.system(size: 20))
                // 進捗率のテキスト
                AnimationReader(percentage) {value in
                    Text("\(value) %")
                        .font(.system(size: 30))
                        .bold()
                }
            }
        }
        .frame(width: 120, height: 120)
        .padding(32.0)
        .onAppear {
            withAnimation(.easeInOut(duration: 1)) {
                isProgress = true
                percentage += Int(progress * 100)
            }
        }
    }
}

struct CircularProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressBarView(progress: 0.8)
    }
}

fileprivate struct AnimationReaderModifier<Body: View>: AnimatableModifier {
    let content: (CGFloat) -> Body
    var animatableData: CGFloat
    
    init(value: CGFloat, @ViewBuilder content: @escaping (CGFloat) -> Body) {
        self.animatableData = value
        self.content = content
    }
    
    func body(content: Content) -> Body {
        self.content(animatableData)
    }
}

struct AnimationReader<Content: View>: View {
    
    let value: CGFloat
    let content: (_ animatingValue: CGFloat) -> Content
    
    init(_ observedValue: Int, @ViewBuilder content: @escaping (_ animatingValue: Int) -> Content) {
        self.value = CGFloat(observedValue)
        self.content = { value in content(Int(value)) }
    }
    
    init(_ observedValue: CGFloat, @ViewBuilder content: @escaping (_ animatingValue: CGFloat) -> Content) {
        self.value = observedValue
        self.content = content
    }
    
    var body: some View {
        EmptyView()
            .modifier(AnimationReaderModifier(value: value, content: content))
    }
}
