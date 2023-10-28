import SwiftUI
import AVFoundation
import Vision

class HandGestureViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate, HandGestureDetectorDelegate {
    // JankenTextModelのインスタンス生成
    var jankenTextModel = JankenTextModel()
    // HandGestureModelのインスタンス
    let handGestureModel = HandGestureModel()

    let handGestureDetector: HandGestureDetector
    // AVCaptureSessionのインスタンス生成
    private let session = AVCaptureSession()
    private var delegate: HandGestureDetectorDelegate?

    @Published var jankenCallTimer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    @Published var currentGesture: HandGestureDetector.HandGesture = .unknown
    // 敵のHPを格納
    @Published var enemyHealthPoint: Double = 1000
    // 敵のHPの背景色
    @Published var enemyHealthColor: [Color] = [.mint, .blue, .blue]
    // ユーザーのHPを格納
    @Published var userHealthPoint: Double = 1000
    // ユーザーのHPの背景色
    @Published var userHealthColor: [Color] = [.mint, .blue, .blue]
    // 逆転後の勝率
    @Published var newWinRate: Int?
    // 敵のジャンケン結果を格納するプロパティ
    @Published var enemyHandGesture: HandGestureDetector.HandGesture = .unknown
    // ジャンケンの結果を格納するプロパティ
    @Published var result: HandGestureModel.GameResult = .aiko
    // jankenTextをPublish
    @Published var jankenText = ""
    // ダメージ
    private let damage: Double = 180

    // MARK: - 研究用 ---------------------------------------------
    // 10試行ごとに勝率を変化させるよう変数（1~5?）
    @Published var winRateChangeCount: Int = 3
    // 全試行の回数（タスクあたりのじゃんけんの回数）
    @Published var taskCount: Int = 5
    // 現在の試行回数
    @Published var currentAttemptCount: Int = 1
    // ユーザーの勝利回数
    @Published var userWinCount: Int = 0
    // 敵の勝利回数
    @Published var enemyWinCount: Int = 0
    // タスクの終了を判定
    @Published var isEndgame: Bool = false
    // 研究用ここまで -----------------------------------------------
    
    /// 課題：「逆転の感覚を強める」
    /// take1
    /// 1タスクあたりの回数を5回にする
    /// ３回目から勝率変化させる

    override init() {
        handGestureDetector = HandGestureDetector()
        super.init()
        handGestureDetector.delegate = self
        do {
            session.sessionPreset = .photo
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
            if let device = device {
                let input = try AVCaptureDeviceInput(device: device)
                session.addInput(input)
                let output = AVCaptureVideoDataOutput()
                output.setSampleBufferDelegate(self, queue: .main)
                session.addOutput(output)
                let view = UIView(frame: UIScreen.main.bounds)
                addPreviewLayer(to: view)
                session.commitConfiguration()
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    // MARK: - メソッド
    // じゃんけんの掛け声用メソッド
    func makeJankenText(jankenCount: Int) {
        jankenText = jankenTextModel.jankenText(jankenCount: jankenCount)
    }
    // 勝率から敵のHandGestureとゲーム結果を算出するメソッド
    func calculateJankenResult(stageSituation: StageSituation) {
        let random = Int.random(in: 1...100)
        // プレーヤーが勝つ閾値→stageSituationのプロパティ使用してるから有効的！
        let userWinNumber = newWinRate ?? stageSituation.winRate
        // プレーヤーが負ける閾値（研究では使用しない←あいこはなしにするから）
        _ = 75 + userWinNumber/4

        // ユーザーの手が正しく認識されているか判定
        if currentGesture == .unknown {
            // リトライと表示
            result = .error
            // 敵の手を？？？にする
            enemyHandGesture = .unknown
        } else {
            if random <= userWinNumber { // プレーヤーの勝ち
                withAnimation {
                    userWinCount += 1
                }
                result = .win
                //                // 敵のHPを減らす
                //                withAnimation {
                //                    self.enemyHealthPoint = handGestureModel.hitPoint(damage: damage, healthPoint: enemyHealthPoint)
                //                }
                // 敵のHPの背景色を更新
                self.enemyHealthColor = handGestureModel.determineHealthPointColor(healthPoint: enemyHealthPoint)
                switch currentGesture {
                case .rock: enemyHandGesture = .scissors
                case .scissors: enemyHandGesture = .paper
                case .paper: enemyHandGesture = .rock
                default: break
                }
            } else { // プレーヤーの負け
                withAnimation {
                    enemyWinCount += 1
                }
                result = .lose
                //                // ユーザーのHPを減らす
                //                withAnimation {
                //                    self.userHealthPoint = handGestureModel.hitPoint(damage: damage, healthPoint: userHealthPoint)
                //                }
                // ユーザーのHPの背景色を更新
                self.userHealthColor = handGestureModel.determineHealthPointColor(healthPoint: userHealthPoint)
                switch currentGesture {
                case .rock: enemyHandGesture = .paper
                case .scissors: enemyHandGesture = .rock
                case .paper: enemyHandGesture = .scissors
                default: break
                }
            }
        }

        // MARK: - 研究用
        // 現在の勝率を確認
        print("研究用：現在の勝率: \(userWinNumber)")
        
        // 現在の試行回数に応じて勝率を変化させる
        if currentAttemptCount >= taskCount {
            // タスク終了
            isEndgame = true
            print("研究用：タスクが終了しました。")
        } else if currentAttemptCount >= winRateChangeCount {
            // 勝率を変更（StageSituatioinの後半の勝率を適用）
            if let newRate = stageSituation.userReversalWin {
                newWinRate = Int(newRate)
            }
            print("研究用：後半の勝率を適用させました。")
        }
        
        print("研究用：現在の試行回数 \(currentAttemptCount)")
        // ここで試行の回数を１追加
        currentAttemptCount += 1
    }

    // ゲームが終了したら勝敗を判定
    func judgeWinner() -> String? {
        return handGestureModel.judgeWinner(enemyHealthPoint: enemyHealthPoint, userHealthPoint: userHealthPoint)
    }

    // handGestureDetector
    func handGestureDetector(_ handGestureDetector: HandGestureDetector, didRecognize gesture: HandGestureDetector.HandGesture) {
        // 何もしない
    }

    // キャプチャを停止するメソッド
    func stop() {
        if session.isRunning {
            session.stopRunning()
            jankenCallTimer.upstream.connect().cancel()
        }
    }

    // キャプチャを再開するメソッド
    func start() {
        if session.isRunning == false {
            // 非同期処理をバックグラウンドスレッドで実行
            DispatchQueue.global().async {
                self.session.startRunning()
            }
            jankenCallTimer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
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
    }
}
