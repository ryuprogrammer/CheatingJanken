//
//  SoundPlayer.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/04/22.
//

import AVFoundation
import UIKit

struct SoundPlayer {
    // 音源データ名をenumで管理
    enum Sound: String {
        case winSound = "winSound"
        case loseSound = "loseSound"
        case buttonSound = "buttonSound"
        case jankenSound = "jankenSound"
    }
    // 音源用プレーヤー変数
    var soundPlayer: AVAudioPlayer!

    // 音源再生
    mutating func soundPlay(soundName: Sound) {
        // 音源データの読み込み
        var soundData: Data? {
            var data: Data?
            if let dataAsset = NSDataAsset(name: soundName.rawValue) {
                data = dataAsset.data
            }
            return data
        }
        do {
            if let soundData = soundData {
                // プレーヤーに音源データを指定
                soundPlayer = try AVAudioPlayer(data: soundData)
                // 音源を再生
                soundPlayer.stop()
                soundPlayer.currentTime = 0.0
                soundPlayer.play()
            }
        } catch {
            print("\(Sound.RawValue.self)の音源がエラーです。")
        }
    }
}
