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
    func handGestureDetector(_ handGestureDetector: HandGestureDetector, didRecognize gesture: HandGestureDetector.HandGesture) {
        // 何もしない
    }
    
    let handGestureDetector: HandGestureDetector
    private let session = AVCaptureSession()
    private var delegate: HandGestureDetectorDelegate?
    var handGestureModel = HandGestureModel()
    
    @Published var currentGesture: HandGestureDetector.HandGesture = .unknown
    
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
