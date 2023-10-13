import AVFoundation
import SwiftUI

// ジャンケンゲームを実装する構造体
class HandGestureModel {
    // ジャンケンの結果のenum
    enum GameResult: String {
        case win = "勝ち！！"
        case lose = "負け。。"
        case aiko = "あいこ"
        case error = "リトライ"
    }

    // SoundPlayerのインスタンス生成
    var soundPlayer = SoundPlayer()

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

    // HPの背景色を決定（青→黄色→赤)
    func determineHealthPointColor(healthPoint: Double) -> [Color] {
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
