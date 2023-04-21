//
//  JankenTextModel.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/04/19.
//

import Foundation
import AVFoundation
import UIKit

struct JankenTextModel {
    let jankenSound = try! AVAudioPlayer(data: NSDataAsset(name: "sound")!.data)
    func jankenText(jankenCount: Int) -> String {
        var jankenText: String = ""
        // カウント毎にテキストを変更する
        switch jankenCount {
        case 0, 1, 2: jankenText = "Ready???"
        case 3:  do {
            jankenText = "最初は、、"
            // jankenSoundを再生
            playJankenSound()
        }
        case 4: jankenText = "ぐー！"
        case 5: jankenText = "じゃんけん"
        case 6, 7: jankenText = "ぽん！！！"
        default: break
        }

        return jankenText
    }
    
    func playJankenSound() {
        // 音声が再生中の場合は音声を再生しない
        if jankenSound.isPlaying == false {
            // 音声をストップする
            jankenSound.stop()
            // 音声を巻き戻す
            jankenSound.currentTime = 0.0
            // 音声を再生
            jankenSound.play()
        }
    }
}
