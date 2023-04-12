//
//  JankenGameModel.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/04/07.
//

import Foundation
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
    let damage: Double = 300

    // 勝率から敵のHandGestureとゲーム結果を算出するメソッド
    func JankenResult(userHandGesture: HandGestureDetector.HandGesture, winRate: Int) {
        let random = Int.random(in: 1...100)
        if random <= winRate { // プレーヤーの勝ち
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
        } else if random <= (100-winRate)/2 { // プレーヤーの負け
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
    func hitPoint(damage: Double, healthPoint: Double) -> Double {
        var newHealthPoint: Double = 1000
        if healthPoint-(damage) > 0 {
            newHealthPoint = healthPoint-(damage)
        } else {
            newHealthPoint = 0.0
        }
        return newHealthPoint
    }

    // HPの背景色を決定（青→黄色→赤）
    func determineHealthPointColor(healthPoint: Double) -> [Color] {
        var healthColor: [Color] = []

        if healthPoint > 500 {
            healthColor = [.mint, .blue, .blue]
        } else if healthPoint > 150 {
            healthColor = [.yellow, .yellow, .orange]
        } else {
            healthColor = [.orange, .red, .red]
        }
        return healthColor
    }

    // ゲームが終了したら勝敗を判定
    func judgeWinner(enemyHealthPoint: Double, userHealthPoint: Double) -> String? {
        // どちらかのHPが0になった時点で終了
        if enemyHealthPoint == 0 || userHealthPoint == 0 {
            if userHealthPoint > 0 {
                return "あなたのかち！"
            } else if enemyHealthPoint > 0 {
                return "あなたの負け。"
            } else {
                return "引き分け"
            }
        }
        return nil
    }
}
