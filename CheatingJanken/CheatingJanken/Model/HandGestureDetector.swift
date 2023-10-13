import Foundation
import Vision

// デリゲートのプロトコルを定義
protocol HandGestureDetectorDelegate: AnyObject {
    // HandGestureDetectorのHandGestureを監視してデリゲート経由でViewに通知する
    func handGestureDetector(_ handGestureDetector: HandGestureDetector, didRecognize gesture: HandGestureDetector.HandGesture)
}

// 検出されたジェスチャーからHandGestureを判別するクラス
class HandGestureDetector: ObservableObject {
    // ジャンケンの手の種類のenum
    enum HandGesture: String {
        case rock = "✊"
        case paper = "✋"
        case scissors = "✌"
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

    // MARK: - メソッド
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

        // HandPoseの判定(どの指が曲がっているかでグーチョキパーを判定する）
        if
            wristToIndexTip > wristToIndexPIP &&
                wristToMiddleTip > wristToMiddlePIP &&
                wristToRingTip > wristToRingPIP &&
                wristToLittleTip > wristToLittlePIP {
            // ４本の指が曲がっていないのでぱー
            currentGesture = .paper
        } else if
            wristToIndexTip < wristToIndexPIP &&
                wristToMiddleTip < wristToMiddlePIP &&
                wristToRingTip < wristToRingPIP &&
                wristToLittleTip < wristToLittlePIP {
            // ４本の指が曲がっているのでぐー
            currentGesture = .rock
        } else if
            wristToIndexTip > wristToIndexPIP &&
                wristToMiddleTip > wristToMiddlePIP {
            // IndexとMiddleが曲がっていないのでちょき
            currentGesture = .scissors
        } else {
            currentGesture = .scissors
        }

        // delegate経由でcurrentGestureを通知する
        delegate?.handGestureDetector(self, didRecognize: currentGesture)
    }

    // 画面上の２点間の距離を三平方の定理より求める
    private func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(pow(from.x - to.x, 2) + pow(from.y - to.y, 2))
    }
}
