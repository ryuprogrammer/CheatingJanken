//
//  CoreMLTestView.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/03/26.
//

import SwiftUI
import Vision
import CoreML

struct CoreMLTestView: View {
    // HandPoseClassiferモデルの読み込み
    let model = try! ImageClassifier2(configuration: MLModelConfiguration())
    // 推測した画像のラベルを格納
    @State var label: String = "push the button"
    // ダミーデータを格納
    let image: [String] = ["image1", "image2", "image3", "image4", "image5", "image6", "image7"]
    // ダミーデータの配列番号を格納
    @State var imageNumber: Int = 0
    
    var body: some View {
        ZStack {
            // 背景色
            Color
                .blue
                .opacity(0.2)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // 推測したラベルを表示
                Text(label)
                    .font(.largeTitle)
                
                // 推測する画像
                Image(image[imageNumber])
                    .resizable()
                    .scaledToFit()
                    .frame(width: 330)
                    .cornerRadius(20)
                
                HStack {
                    // 前の画像を表示するボタン
                    Button {
                        if imageNumber == 0 {
                            imageNumber = 6
                        } else {
                            imageNumber -= 1
                        }
                    } label: {
                        Text("Buck")
                            .foregroundColor(Color.green.opacity(0.8))
                            .font(.title)
                            .frame(width: 80, height: 60)
                            .background(Color.white)
                            .cornerRadius(18)
                    }
                    
                    // 推測ボタン
                    Button {
                        classification()
                        print(label)
                    } label: {
                        Text("Classifer")
                            .foregroundColor(Color.white)
                            .font(.title)
                            .frame(width: 150, height: 60)
                            .background(Color.green)
                            .cornerRadius(18)
                    }
                    
                    // 次の画像を表示するボタン
                    Button {
                        if imageNumber == 6 {
                            imageNumber = 0
                        } else {
                            imageNumber += 1
                        }
                    } label: {
                        Text("Next")
                            .foregroundColor(Color.green.opacity(0.8))
                            .font(.title)
                            .frame(width: 80, height: 60)
                            .background(Color.white)
                            .cornerRadius(18)
                    }
                }
            }
        }
    }
    
    // 推測するメソッド
    private func classification() {
        let img = UIImage(named: image[imageNumber])
        guard  let resized = img?.resizeTo(size: CGSize(width: 299, height: 299)),
               let buffer = resized.toBuffer() else { return }
        let output = try? model.prediction(image: buffer)
        if let output = output {
            label = output.classLabel
        } else {
            label = "error"
        }
    }
}

// UIImageの拡張
extension UIImage {
    func resizeTo(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    func toBuffer() -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
             kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(self.size.width), Int(self.size.height),
                                         kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
}

struct CoreMLTestView_Previews: PreviewProvider {
    static var previews: some View {
        CoreMLTestView()
    }
}
