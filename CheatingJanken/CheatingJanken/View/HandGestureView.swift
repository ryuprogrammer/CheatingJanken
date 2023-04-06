//
//  HandGestureTestView.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/04/03.
//

import SwiftUI
import AVFoundation
import Vision

struct HandGestureView: View {
    // CameraModelのインスタンス生成
    @ObservedObject var camera = CameraModel()
    // JankenGameのインスタンス生成
    @StateObject var jankenGame = JankenGame()
    // Viewの背景色のプロパティ
    @State private var backgroundColor = Color.red
    // カメラのオンオフを切り替えるプロパティ
    @State private var isCamera = false
    // ジャンケンのカウントダウン用プロパティ
    @State private var jankenCount: Int = 0
    // 決められた時間毎にイベントを発行
    @State private var timer = Timer.publish(every: 0.7, on: .main, in: .common).autoconnect()
    // ジャンケンの掛け声
    @State private var jankenText: String = ""
    // 敵のジャンケン結果の表示有無
    @State private var isShowEnemy: Bool = false
    
    var body: some View {
        ZStack {
            CameraView(camera: camera)
                .edgesIgnoringSafeArea(.all)
            
            backgroundColor.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // 敵のジャンケン結果
                if isShowEnemy {
                    Text("てき：\(jankenGame.enemyHandGesture.rawValue)")
                        .bold()
                        .font(.system(size: 50))
                        .foregroundColor(Color.white)
                    
                    Text("結果：\(jankenGame.result)")
                        .bold()
                        .font(.system(size: 50))
                        .foregroundColor(Color.white)
                } else {
                    // ジャンケンのカウントダウン
                    Text(jankenText)
                        .bold()
                        .font(.system(size: 50))
                        .foregroundColor(Color.white)
                        .onReceive(timer) { _ in
                            jankenCount += 1
                            if jankenCount >= 8 {
                                camera.stop()
                                jankenGame.JankenResult(userHandGesture: HandGestureDetector.HandGesture(rawValue: camera.handGestureDetector.currentGesture.rawValue) ?? .unknown)
                                isShowEnemy = true
                                isCamera = false
                                timer.upstream.connect().cancel()
                            }
                        }
                }
                
                Text("あなた：\(camera.handGestureDetector.currentGesture.rawValue)") // @Publishedプロパティを使用
                    .bold()
                    .font(.system(size: 50))
                    .foregroundColor(Color.white)
                
                Spacer()
                    .frame(height: 200)
                
                // カメラのオンオフの切り替え
                Button {
                    if isCamera {
                        camera.stop()
                    } else {
                        isShowEnemy = false
                        jankenCount = 0
                        timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
                        camera.start()
                    }
                    isCamera.toggle()
                } label: {
                    Text(isCamera ? "ストップ" : "もう一回")
                        .bold()
                        .font(.system(size: 50))
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 80)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(20)
                }
            }
            .onChange(of: jankenCount) { jankenCount in
                // カウント毎にテキストを変更する
                switch jankenCount {
                case 0...3: jankenText = "Ready???"
                case 4: jankenText = "最初は、、"
                case 5: jankenText = "ぐー！"
                case 6: jankenText = "じゃんけん、、"
                case 7,8: jankenText = "ぽん！！！"
                default: break
                }
            }
        }
        // currentGestureに応じて背景色を変化させる
        .onChange(of: camera.handGestureDetector.currentGesture.rawValue) { currentGesture in
            withAnimation {
                backgroundColor = (currentGesture == "？？？" ? .red : .green)
            }
        }
    }
}

// ジャンケンゲームを実装する構造体
class JankenGame: ObservableObject {
    // HandGestureDetectorのインスタンス生成
    let handGestureDetector = HandGestureDetector()
    // 敵のジャンケン結果を格納するプロパティ
    var enemyHandGesture: HandGestureDetector.HandGesture = .unknown
    // ジャンケンの結果を格納するプロパティ
    var result: String = ""
    // 勝率を格納するプロパティ（JankenResultの計算上「偶数」にする）
    let winRate: Int = 2 // 2 %
    
    // 勝率から敵のHandGestureとゲーム結果を算出するメソッド
    func JankenResult(userHandGesture: HandGestureDetector.HandGesture) {
        let random = Int.random(in: 1...100)
        if random <= winRate { // プレーヤーの勝ち
            result = "勝ち！"
            switch userHandGesture {
            case .rock: enemyHandGesture = .scissors
            case .scissors: enemyHandGesture = .paper
            case .paper: enemyHandGesture = .rock
            default: break
            }
        } else if random <= (100-winRate)/2 { // プレーヤーの負け
            result = "負け、、"
            switch userHandGesture {
            case .rock: enemyHandGesture = .paper
            case .scissors: enemyHandGesture = .rock
            case .paper: enemyHandGesture = .scissors
            default: break
            }
        } else { // あいこ
            result = "あいこ"
            switch userHandGesture {
            case .rock: enemyHandGesture = .rock
            case .scissors: enemyHandGesture = .scissors
            case .paper: enemyHandGesture = .paper
            default: break
            }
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
        let coordinator = Coordinator(camera: camera)
        camera.handGestureDetector.delegate = coordinator // Coodinatorをデリゲートとして設定
        return coordinator
    }
    
    class Coordinator: NSObject, HandGestureDetectorDelegate {
        @ObservedObject var camera: CameraModel // CameraModelを監視可能にするために@ObservedObjectを追加
        
        init(camera: CameraModel) {
            self.camera = camera
        }
        
        // HandGestureを判定してcurrentGesture（画面に表示するプロパティ）に格納
        func handGestureDetector(_ handGestureDetector: HandGestureDetector, didRecognize gesture: HandGestureDetector.HandGesture) {
            DispatchQueue.main.async {
                self.camera.currentGesture = gesture // @Publishedプロパティに値を設定
            }
        }
    }
}

class CameraModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate, HandGestureDetectorDelegate {
    func handGestureDetector(_ handGestureDetector: HandGestureDetector, didRecognize gesture: HandGestureDetector.HandGesture) {
    }
    
    let session = AVCaptureSession()
    let handGestureDetector: HandGestureDetector
    weak var delegate: HandGestureDetectorDelegate?
    
    @Published var currentGesture: HandGestureDetector.HandGesture = .unknown // @Publishedプロパティに変更
    
    override init() {
        handGestureDetector = HandGestureDetector()
        super.init()
        handGestureDetector.delegate = self
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
    
    // キャプチャを停止するメソッド
    func stop() {
        session.stopRunning()
    }
    
    // キャプチャを再開するメソッド
    func start() {
        session.startRunning()
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
    }
}

// デリゲートのプロトコルを定義
protocol HandGestureDetectorDelegate: AnyObject {
    // HandGestureDetectorのHandGestureを監視してデリゲート経由でViewに通知する
    func handGestureDetector(_ handGestureDetector: HandGestureDetector, didRecognize gesture: HandGestureDetector.HandGesture)
}

// 検出されたジェスチャーからHandGestureを判別するクラス
class HandGestureDetector: ObservableObject {
    // ジャンケンの手の種類のenum
    enum HandGesture: String {
        case rock = "グー"
        case paper = "パー"
        case scissors = "チョキ"
        case unknown = "？？？"
    }
    
    // デリゲートメソッドに渡す用のHandGestureプロパティ
    var currentGesture: HandGesture = .unknown {
        didSet {
            delegate?.handGestureDetector(self, didRecognize: currentGesture)
        }
    }
    
    // デリゲートを持たせるためのプロパティ
    weak var delegate: HandGestureDetectorDelegate?
    
    // デリゲートを初期化
    init(delegate: HandGestureDetectorDelegate? = nil) {
        self.delegate = delegate
    }
    
    func createDetectionRequest(pixelBuffer: CVPixelBuffer) throws -> VNImageBasedRequest {
        // 人間の手を検出するリクエストクラスのインスタンス生成
        let request = VNDetectHumanHandPoseRequest()
        // 画像内で検出する手の最大数
        request.maximumHandCount = 1
        // 画像内に関する１つ以上の画像分析を要求する処理
        try VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        return request
    }
    
    // HandPoseを判別するメソッド
    func processObservations(_ observations: [VNRecognizedPointsObservation]) {
        guard let points = try? observations.first?.recognizedPoints(forGroupKey: .all) else {
            return
        }
        
        // 指先
        let indexTip = points[VNHumanHandPoseObservation.JointName.indexTip.rawValue]?.location ?? .zero
        let middleTip = points[VNHumanHandPoseObservation.JointName.middleTip.rawValue]?.location ?? .zero
        let ringTip = points[VNHumanHandPoseObservation.JointName.ringTip.rawValue]?.location ?? .zero
        let littleTip = points[VNHumanHandPoseObservation.JointName.littleTip.rawValue]?.location ?? .zero
        // 近位指節間(PIP)関節 ＝ 第二関節のこと
        let indexPIP = points[VNHumanHandPoseObservation.JointName.indexPIP.rawValue]?.location ?? .zero
        let middlePIP = points[VNHumanHandPoseObservation.JointName.middlePIP.rawValue]?.location ?? .zero
        let ringPIP = points[VNHumanHandPoseObservation.JointName.ringPIP.rawValue]?.location ?? .zero
        let littlePIP = points[VNHumanHandPoseObservation.JointName.littlePIP.rawValue]?.location ?? .zero
        // 手首
        let wrist = points[VNHumanHandPoseObservation.JointName.wrist.rawValue]?.location ?? .zero
        
        // 親指の指先と関節２つと手根中手骨
        let thumbTip = points[VNHumanHandPoseObservation.JointName.thumbTip.rawValue]?.location ?? .zero
        let thumbIP = points[VNHumanHandPoseObservation.JointName.thumbIP.rawValue]?.location ?? .zero
        let thumbMP = points[VNHumanHandPoseObservation.JointName.thumbMP.rawValue]?.location ?? .zero
        let thumbCMC = points[VNHumanHandPoseObservation.JointName.thumbCMC.rawValue]?.location ?? .zero
        
        // 手首から指先の長さ
        let wristToIndexTip = distance(from: wrist, to: indexTip)
        let wristToMiddleTip = distance(from: wrist, to: middleTip)
        let wristToRingTip = distance(from: wrist, to: ringTip)
        let wristToLittleTip = distance(from: wrist, to: littleTip)
        
        // 手首から近位指節間(PIP)関節の長さ
        let wristToIndexPIP = distance(from: wrist, to: indexPIP)
        let wristToMiddlePIP = distance(from: wrist, to: middlePIP)
        let wristToRingPIP = distance(from: wrist, to: ringPIP)
        let wristToLittlePIP = distance(from: wrist, to: littlePIP)
        
        // 親指の関節の角度
        let thumbIpAngle = angleFromThreePoints(point1: thumbTip, point2: thumbIP, point3: thumbMP)
        let thumbMpAngle = angleFromThreePoints(point1: thumbIP, point2: thumbMP, point3: thumbCMC)
        
        // 人差し指が曲がっているかチェック
        if wristToIndexTip > wristToIndexPIP {
            print("人差し指：まっすぐ")
        } else if wristToIndexTip < wristToIndexPIP {
            print("人差し指：曲がってる")
        }
        // 中指が曲がっているかチェック
        if wristToMiddleTip > wristToMiddlePIP {
            print("中指：まっすぐ")
        } else if wristToMiddleTip < wristToMiddlePIP {
            print("中指：曲がってる")
        }
        // 薬指が曲がっているかチェック
        if wristToRingTip > wristToRingPIP {
            print("薬指：まっすぐ")
        } else if wristToRingTip < wristToRingPIP {
            print("薬指：曲がってる")
        }
        // 小指が曲がっているかチェック
        if wristToLittleTip > wristToLittlePIP {
            print("小指：まっすぐ")
        } else if wristToLittleTip < wristToLittlePIP {
            print("小指：曲がってる")
        }
        
        print("親指")
        print("thumbIpAngle：\(thumbIpAngle)")
        print("thumbMpAngle：\(thumbMpAngle)")
        
        // HandPoseの判定(どの指が曲がっているかでグーチョキパーを判定する）
        if
            wristToIndexTip > wristToIndexPIP &&
                wristToMiddleTip > wristToMiddlePIP &&
                wristToRingTip > wristToRingPIP &&
                wristToLittleTip > wristToLittlePIP {
            // ４本の指が曲がっていないのでぱー
            currentGesture = .paper
        } else if
            wristToIndexTip > wristToIndexPIP &&
                wristToMiddleTip > wristToMiddlePIP &&
                wristToRingTip < wristToRingPIP &&
                wristToLittleTip < wristToLittlePIP {
            // IndexとMiddleが曲がっていないのでちょき
            currentGesture = .scissors
        } else if
            wristToIndexTip < wristToIndexPIP &&
                wristToMiddleTip < wristToMiddlePIP &&
                wristToRingTip < wristToRingPIP &&
                wristToLittleTip < wristToLittlePIP {
            // ４本の指が曲がっているのでぐー
            currentGesture = .rock
        } else {
            currentGesture = .unknown
        }
        
        print(currentGesture.rawValue)
        print("--------------")
        
        // デリゲートを呼び出す
        delegate?.handGestureDetector(self, didRecognize: currentGesture) // delegate 経由で currentGesture を通知する
    }
    
    // 画面上の２点間の距離を三平方の定理より求める
    private func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(pow(from.x - to.x, 2) + pow(from.y - to.y, 2))
    }
    
    // 画面上の３点の角度を求める
    private func angleFromThreePoints(point1: CGPoint, point2: CGPoint, point3: CGPoint) -> Double {
        let v1x = point2.x - point1.x
        let v1y = point2.y - point1.y
        let v2x = point2.x - point3.x
        let v2y = point2.y - point3.y
        
        let dotProduct = v1x * v2x + v1y * v2y
        let length_v1 = sqrt(v1x * v1x + v1y * v1y)
        let length_v2 = sqrt(v2x * v2x + v2y * v2y)
        
        let angle = acos(dotProduct / (length_v1 * length_v2))
        return angle
    }
}

struct HandGestureView_Previews: PreviewProvider {
    static var previews: some View {
        HandGestureView()
    }
}
