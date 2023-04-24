//
//  JankenGameModel.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/04/07.
//

import Foundation
import AVFoundation
import SwiftUI

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
    // 敵のHPを格納
    var enemyHealthPoint: Double = 1000
    // 敵のHPの背景色
    var enemyHealthColor: [Color] = [.mint, .blue, .blue]
    // ユーザーのHPを格納
    var userHealthPoint: Double = 1000
    // ユーザーのHPの背景色
    var userHealthColor: [Color] = [.mint, .blue, .blue]
    // ダメージ
    let damage: Double = 180
    // 逆転後の勝率
    var newWinRate: Int?
    // SoundPlayerのインスタンス生成
    var soundPlayer = SoundPlayer()

    // 勝率から敵のHandGestureとゲーム結果を算出するメソッド
    func JankenResult(userHandGesture: HandGestureDetector.HandGesture,
                      stageSituation: StageSituation) {
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
        if random <= userWinNumber { // プレーヤーの勝ち
            result = .win
            // 敵のHPを減らす
            enemyHealthPoint = hitPoint(damage: damage, healthPoint: enemyHealthPoint)
            // 敵のHPの背景色を更新
            enemyHealthColor = determineHealthPointColor(healthPoint: enemyHealthPoint)
            switch userHandGesture {
            case .rock: enemyHandGesture = .scissors
            case .scissors: enemyHandGesture = .paper
            case .paper: enemyHandGesture = .rock
            default: break
            }
        } else if random <= userLoseNumber { // プレーヤーの負け
            result = .lose
            // ユーザーのHPを減らす
            userHealthPoint = hitPoint(damage: damage, healthPoint: userHealthPoint)
            // ユーザーのHPの背景色を更新
            userHealthColor = determineHealthPointColor(healthPoint: userHealthPoint)
            switch userHandGesture {
            case .rock: enemyHandGesture = .paper
            case .scissors: enemyHandGesture = .rock
            case .paper: enemyHandGesture = .scissors
            default: break
            }
        } else { // あいこ
            result = .aiko
            // ユーザーのHPを少し減らす
            userHealthPoint = hitPoint(damage: damage*0.1, healthPoint: userHealthPoint)
            // 敵のHPを少し減らす
            enemyHealthPoint = hitPoint(damage: damage*0.1, healthPoint: enemyHealthPoint)
            // ユーザーのHPの背景色を更新
            userHealthColor = determineHealthPointColor(healthPoint: userHealthPoint)
            // 敵のHPの背景色を更新
            enemyHealthColor = determineHealthPointColor(healthPoint: enemyHealthPoint)
            switch userHandGesture {
            case .rock: enemyHandGesture = .rock
            case .scissors: enemyHandGesture = .scissors
            case .paper: enemyHandGesture = .paper
            default: break
            }
        }
    }

    // HPを計算
    private func hitPoint(damage: Double, healthPoint: Double) -> Double {
        var newHealthPoint: Double = 1000
        if healthPoint-(damage) > 0 {
            newHealthPoint = healthPoint-(damage)
        } else {
            newHealthPoint = 0.0
        }
        return newHealthPoint
    }

    // HPの背景色を決定（青→黄色→赤)
    private func determineHealthPointColor(healthPoint: Double) -> [Color] {
        var healthColor: [Color] = []
        let highHealthPoint: Double = 500
        let normalHealthPoint: Double = 150

        if healthPoint > highHealthPoint {
            healthColor = [.mint, .blue, .blue]
        } else if healthPoint > normalHealthPoint {
            healthColor = [.yellow, .yellow, .orange]
        } else {
            healthColor = [.orange, .red, .red]
        }
        return healthColor
    }

    // ゲームが終了したら勝敗を判定
    func judgeWinner(enemyHealthPoint: Double, userHealthPoint: Double) -> String? {
        let deathHealthPoint: Double = 0
        // どちらかのHPがdeathHealthPointになった時点で終了
        if enemyHealthPoint == deathHealthPoint || userHealthPoint == deathHealthPoint {
            if userHealthPoint > deathHealthPoint {
                soundPlayer.soundPlay(soundName: .winSound)
                return GameResult.win.rawValue
            } else if enemyHealthPoint > deathHealthPoint {
                soundPlayer.soundPlay(soundName: .loseSound)
                return GameResult.lose.rawValue
            } else {
                // ずっとあいこの場合
                return GameResult.aiko.rawValue
            }
        }
        return nil
    }
}
