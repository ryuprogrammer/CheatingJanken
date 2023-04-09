//
//  JankenGameModel.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/04/07.
//

import Foundation

// ジャンケンゲームを実装する構造体
class HandGestureModel {
    // ジャンケンの結果のenum
    enum GameResult: String {
        case win = "勝ち！！"
        case lose = "負け。。"
        case aiko = "あいこ"
    }
    
    // 敵のジャンケン結果を格納するプロパティ
    var enemyHandGesture: HandGestureDetector.HandGesture = .unknown
    // ジャンケンの結果を格納するプロパティ
    var result: GameResult = .aiko
    
    // 勝率から敵のHandGestureとゲーム結果を算出するメソッド
    func JankenResult(userHandGesture: HandGestureDetector.HandGesture, winRate: Int) {
        let random = Int.random(in: 1...100)
        if random <= winRate { // プレーヤーの勝ち
            result = .win
            switch userHandGesture {
            case .rock: enemyHandGesture = .scissors
            case .scissors: enemyHandGesture = .paper
            case .paper: enemyHandGesture = .rock
            default: break
            }
        } else if random <= (100-winRate)/2 { // プレーヤーの負け
            result = .lose
            switch userHandGesture {
            case .rock: enemyHandGesture = .paper
            case .scissors: enemyHandGesture = .rock
            case .paper: enemyHandGesture = .scissors
            default: break
            }
        } else { // あいこ
            result = .aiko
            switch userHandGesture {
            case .rock: enemyHandGesture = .rock
            case .scissors: enemyHandGesture = .scissors
            case .paper: enemyHandGesture = .paper
            default: break
            }
        }
    }
}
