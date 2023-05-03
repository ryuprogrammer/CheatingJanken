//
//  CameraModel.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/04/07.
//

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

    @Published var jankenCallTimer = Timer.publish(every: 0.8, on: .main, in: .common).autoconnect()
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
        // 逆転勝利の有無によってwinRateを増加
        if let userReversalWin = stageSituation.userReversalWin {
            if userHealthPoint <= 1000*userReversalWin {
                // 勝率が90%を超えないようにminを使用
                newWinRate = min(stageSituation.winRate + 30, 90)
            }
        }
        // 逆転負けの有無によってwinRateを減少
        if let userReversalLose = stageSituation.userReversalLose {
            if enemyHealthPoint <= 1000*userReversalLose {
                // 勝率が10%を下回らないようにmaxを使用
                newWinRate = max(stageSituation.winRate - 30, 10)
            }
        }

        let random = Int.random(in: 1...100)
        // プレーヤーが勝つ閾値
        let userWinNumber = newWinRate ?? stageSituation.winRate
        // プレーヤーが負ける閾値
        let userLoseNumber = 75 + userWinNumber/4
        // ユーザーの手が正しく認識されているか判定
        if currentGesture == .unknown {
            // リトライと表示
            result = .error
            // 敵の手を？？？にする
            enemyHandGesture = .unknown
        } else {
            if random <= userWinNumber { // プレーヤーの勝ち
                result = .win
                // 敵のHPを減らす
                withAnimation {
                    self.enemyHealthPoint = handGestureModel.hitPoint(damage: damage, healthPoint: enemyHealthPoint)
                }
                // 敵のHPの背景色を更新
                self.enemyHealthColor = handGestureModel.determineHealthPointColor(healthPoint: enemyHealthPoint)
                switch currentGesture {
                case .rock: enemyHandGesture = .scissors
                case .scissors: enemyHandGesture = .paper
                case .paper: enemyHandGesture = .rock
                default: break
                }
            } else if random <= userLoseNumber { // プレーヤーの負け
                result = .lose
                // ユーザーのHPを減らす
                withAnimation {
                    self.userHealthPoint = handGestureModel.hitPoint(damage: damage, healthPoint: userHealthPoint)
                }
                // ユーザーのHPの背景色を更新
                self.userHealthColor = handGestureModel.determineHealthPointColor(healthPoint: userHealthPoint)
                switch currentGesture {
                case .rock: enemyHandGesture = .paper
                case .scissors: enemyHandGesture = .rock
                case .paper: enemyHandGesture = .scissors
                default: break
                }
            } else { // あいこ
                result = .aiko
                // ユーザーのHPを少し減らす
                withAnimation {
                    self.userHealthPoint = handGestureModel.hitPoint(damage: damage*0.1, healthPoint: userHealthPoint)
                }
                // 敵のHPを少し減らす
                self.enemyHealthPoint = handGestureModel.hitPoint(damage: damage*0.1, healthPoint: enemyHealthPoint)
                // ユーザーのHPの背景色を更新
                self.userHealthColor = handGestureModel.determineHealthPointColor(healthPoint: userHealthPoint)
                // 敵のHPの背景色を更新
                self.enemyHealthColor = handGestureModel.determineHealthPointColor(healthPoint: enemyHealthPoint)
                switch currentGesture {
                case .rock: enemyHandGesture = .rock
                case .scissors: enemyHandGesture = .scissors
                case .paper: enemyHandGesture = .paper
                default: break
                }
            }
        }
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
            jankenCallTimer = Timer.publish(every: 0.8, on: .main, in: .common).autoconnect()
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
