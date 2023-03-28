//
//  GameView.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/03/19.
//

import SwiftUI
import AVFoundation

struct GameView: View {
    @Environment(\.dismiss) var dismiss
    @State var isStart: Bool = false
    // HandPoseClassifiler2モデルのインスタンス生成
    @StateObject var handPoseClassifier = HandPoseClassifier()
    var body: some View {
        ZStack {
            VStack {
                Color("sky")
                Color("green")
            }
            .ignoresSafeArea()
            
            Image("gameView")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()
                .offset(y: -30)
            
            VStack(spacing: 20) {
                
                Spacer()
                    .frame(height: 100)
                
                ZStack {
                    Image(systemName: "hand.wave.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .padding(30)
                        .background(Color.cyan.opacity(0.6))
                        .cornerRadius(70)
                        .frame(width: 190)
                        .offset(x: -90)
                    
                    Text("ロボット")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color.cyan)
                        .frame(width: 130, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                        .offset(x: -90, y: -90)
                }
                
                Text("スタートボタンを押してね！")
                    .font(.title)
                    .foregroundColor(Color.cyan)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .background(Color.white.opacity(0.7))
                    .onTapGesture {
                        dismiss()
                    }
                
                Spacer()
                
                if isStart {
                    ZStack {
                        CameraPreview(session: handPoseClassifier.cameraFeedSession)
                            .frame(width: UIScreen.main.bounds.width/2,
                                   height: UIScreen.main.bounds.height/2)
                            .cornerRadius(70)
//                        Image("camera")
//                            .resizable()
//                            .scaledToFit()
//                            .cornerRadius(70)
//                            .frame(width: 220, height: 300)
                        
                        Rectangle()
                            .foregroundColor(Color.cyan)
                            .opacity(0.5)
                            .cornerRadius(70)
                            .frame(width: 220, height: 300)
                        
                        Image(systemName: "hand.wave.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white.opacity(0.6))
                            .padding(30)
                            .cornerRadius(70)
                            .frame(width: 220, height: 300)
                        
                        Text(handPoseClassifier.predictionResult ?? "Unknown")
                            .font(.title)
                            .bold()
                            .foregroundColor(Color.cyan)
                            .frame(width: 220, height: 40)
                            .background(Color.white)
                            .cornerRadius(10)
                            .offset(y: -130)
                    }
                } else {
                    Button {
                        isStart = true
                    } label: {
                        Text("スタート")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(Color.cyan)
                            .frame(width: 220, height: 300)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(20)
                    }
                }
                
                Spacer()
            }
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession?

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)

        guard let session = session else {
            return view
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
