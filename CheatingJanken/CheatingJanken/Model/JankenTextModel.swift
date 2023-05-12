//
//  JankenTextModel.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/04/19.
//

import Foundation

struct JankenTextModel {
    // soundPlayerのインスタンス生成
    var soundPlayer = SoundPlayer()

    // ジャンケンの掛け声用のメソッド
    mutating func jankenText(jankenCount: Int) -> String {
        var jankenText: String = ""
        // カウント毎にテキストを変更する
        switch jankenCount {
        case 0...10: jankenText = "Ready???"
        case 11: do {
            jankenText = "最初は、、"
            // jankenSoundを再生
            soundPlayer.soundPlay(soundName: .jankenSound)
        }
        case 12...14: jankenText = "最初は、、"
        case 15...18: jankenText = "ぐー！"
        case 19...22: jankenText = "じゃんけん"
        case 23...25: jankenText = "ぽん！！！"
        default: break
        }
        return jankenText
    }
}
