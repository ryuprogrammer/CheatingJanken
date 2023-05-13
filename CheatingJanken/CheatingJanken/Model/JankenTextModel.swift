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
        let readyCount = 0...10
        let firstCount = 11
        let secondCount = 15...18
        let thirdCount = 19...22
        let finalCount = 23...25
        
        // カウント毎にテキストを変更する
        switch jankenCount {
        case readyCount: jankenText = "Ready???"
        case firstCount: do {
            jankenText = "最初は、、"
            // jankenSoundを再生
            soundPlayer.soundPlay(soundName: .jankenSound)
        }
        case secondCount: jankenText = "ぐー！"
        case thirdCount: jankenText = "じゃんけん"
        case finalCount: jankenText = "ぽん！！！"
        default: break
        }
        return jankenText
    }
}
