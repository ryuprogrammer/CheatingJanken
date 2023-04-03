//
//  HandGestureTestView.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/04/03.
//

import SwiftUI
import AVFoundation
import Vision

struct HandGestureTestView: View {
    // CameraModelのインスタンス生成
    @StateObject var camera = CameraModel()
    var body: some View {
        ZStack {
            CameraView(camera: camera) // @ObservedObjectを追加
                .edgesIgnoringSafeArea(.all)
            
            Text(camera.currentGesture.rawValue) // @Publishedプロパティを使用
                .font(.system(size: 50))
        }
        .onAppear {
            print(camera.currentGesture.rawValue)
        }
        // 念の為onChangeでcurrentGestureが変化しているか確認のために書きました。
        .onChange(of: camera.currentGesture.rawValue) { newValue in
            print(newValue)
        }
    }
}

// カメラのプレビューレイヤーを設定
struct CameraView: UIViewRepresentable {
    @ObservedObject var camera: CameraModel
    
    func makeUIView(context: Context) -> UIView {
        let previewView = UIView(frame: UIScreen.main.bounds)
        camera.addPreviewLayer(to: previewView)
        context.coordinator.camera = camera // CoordinatorにCameraModelを渡す
        return previewView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // ここでは何もしない。
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(camera: camera) // Coordinatorの初期化時にCameraModelを渡す
    }
    
    class Coordinator: NSObject, HandGestureDetectorDelegate {
        @ObservedObject var camera: CameraModel // CameraModelを監視可能にするために@ObservedObjectを追加
        
        init(camera: CameraModel) {
            self.camera = camera
        }
        
        // HandGestureを判定してcurrentGesture（画面に表示する変数）に格納
        func handGestureDetector(_ handGestureDetector: HandGestureDetector, didRecognize gesture: HandGestureDetector.HandGesture) {
            DispatchQueue.main.async {
                self.camera.currentGesture = gesture // @Publishedプロパティに値を設定
            }
        }
    }
}

class CameraModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    let session = AVCaptureSession()
    let handGestureDetector = HandGestureDetector()
    
    @Published var currentGesture: HandGestureDetector.HandGesture = .unknown // @Publishedプロパティに変更
    
    override init() {
        super.init()
        do {
            session.sessionPreset = .photo
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
            let input = try AVCaptureDeviceInput(device: device!)
            session.addInput(input)
            let output = AVCaptureVideoDataOutput()
            output.setSampleBufferDelegate(self, queue: .main)
            session.addOutput(output)
            let view = UIView(frame: UIScreen.main.bounds)
            addPreviewLayer(to: view)
            session.commitConfiguration()
            session.startRunning()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // キャプチャセッションから得られたカメラ映像を表示するためのレイヤーを追加するメソッド
    func addPreviewLayer(to view: UIView) {
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.frame = UIScreen.main.bounds
        layer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(layer) // UIViewにAVCaptureVideoPreviewLayerを追加
    }
    
    // AVCaptureVideoDataOutputから取得した動画フレームからてのジェスチャーを検出するメソッド
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let request = try? handGestureDetector.createDetectionRequest(pixelBuffer: pixelBuffer)
        
        guard let observations = request?.results as? [VNRecognizedPointsObservation] else {
            return
        }
        
        // 実際にジェスチャーからHandGestureを判別する
        handGestureDetector.processObservations(observations)
        // currentGesture.rawValueが更新されているかチェック→ずっと？？？のまま。
        print(currentGesture.rawValue)
    }
}

protocol HandGestureDetectorDelegate: AnyObject {
    func handGestureDetector(_ handGestureDetector: HandGestureDetector, didRecognize gesture: HandGestureDetector.HandGesture)
}

// 検出されたジェスチャーからHandGestureを判別するクラス
class HandGestureDetector {
    enum HandGesture: String {
        case rock = "グー"
        case paper = "パー"
        case scissors = "チョキ"
        case test = "processObservationsメソッド内のif文は実行されています。"
        case unknown = "？？？"
    }
    
    var currentGesture: HandGesture = .unknown
    var delegate: HandGestureDetectorDelegate?
    
    func createDetectionRequest(pixelBuffer: CVPixelBuffer) throws -> VNImageBasedRequest {
        let request = VNDetectHumanHandPoseRequest()
        request.maximumHandCount = 1
        try VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        return request
    }
    
    func processObservations(_ observations: [VNRecognizedPointsObservation]) {
        guard let points = try? observations.first?.recognizedPoints(forGroupKey: .all/*,
                                                                                       intent: VNRecognizedPointGroupObservationIntent*/) else {
            return
        }
        
        let thumbTip = points[VNHumanHandPoseObservation.JointName.thumbTip.rawValue]?.location ?? .zero
        let indexTip = points[VNHumanHandPoseObservation.JointName.indexTip.rawValue]?.location ?? .zero
        let middleTip = points[VNHumanHandPoseObservation.JointName.middleTip.rawValue]?.location ?? .zero
        let ringTip = points[VNHumanHandPoseObservation.JointName.ringTip.rawValue]?.location ?? .zero
        let littleTip = points[VNHumanHandPoseObservation.JointName.littleTip.rawValue]?.location ?? .zero
        
        if distance(from: indexTip, to: middleTip) < 50 && distance(from: middleTip, to: ringTip) < 50 && distance(from: ringTip, to: littleTip) < 50 {
            currentGesture = .rock
        } else if distance(from: thumbTip, to: indexTip) < 50 && distance(from: indexTip, to: middleTip) < 50 {
            currentGesture = .paper
        } else if distance(from: thumbTip, to: indexTip) > 50 && distance(from: indexTip, to: middleTip) > 50 && distance(from: middleTip, to: ringTip) > 50 && distance(from: ringTip, to: littleTip) < 50 {
            currentGesture = .scissors
        } else {
            currentGesture = .test
        }
        print("手が検出されています。")
        
        delegate?.handGestureDetector(self, didRecognize: currentGesture) // delegate 経由で currentGesture を通知する
    }
    
    private func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(pow(from.x - to.x, 2) + pow(from.y - to.y, 2))
    }
}


struct HandGestureTestView_Previews: PreviewProvider {
    static var previews: some View {
        HandGestureTestView()
    }
}
