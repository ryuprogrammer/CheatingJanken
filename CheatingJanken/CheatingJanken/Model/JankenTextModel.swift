//
//  JankenTextModel.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/04/19.
//

import Foundation

struct JankenTextModel {
    // soundPlayerのインスタンス生成
    let soundPlayer = SoundPlayer()

    // ジャンケンの掛け声用のメソッド
    func jankenText(jankenCount: Int) -> String {
        var jankenText: String = ""
        // カウント毎にテキストを変更する
        switch jankenCount {
        case 0, 1, 2: jankenText = "Ready???"
        case 3:  do {
            jankenText = "最初は、、"
            // jankenSoundを再生
            soundPlayer.jankenSoundPlay()
        }
        case 4: jankenText = "ぐー！"
        case 5: jankenText = "じゃんけん"
        case 6, 7: jankenText = "ぽん！！！"
        default: break
        }
        return jankenText
    }
}
