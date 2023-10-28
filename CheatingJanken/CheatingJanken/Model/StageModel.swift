import Foundation
import AVFoundation

struct StageModel {
    let stageSituations: [StageSituation] = [
        // タスク１: 統制タスク（勝率の変化なし。常に勝率50%）
        StageSituation(
            imageName: "001",
            level: 0001,
            winRate: 50,
            userReversalWin: 50,
            userReversalLose: nil
        ),
        // タスク２: 圧勝タスク（勝率80%）
        StageSituation(
            imageName: "001",
            level: 0002,
            winRate: 80,
            userReversalWin: 80,
            userReversalLose: nil
        ),
        // タスク３: 逆転勝利タスク（勝率5%→95%）
        StageSituation(
            imageName: "001",
            level: 0003
            , winRate: 5
            , userReversalWin: 95
            , userReversalLose: nil
        )
    ]
    // soundPlayerのインスタンス生成
    var soundPlayer = SoundPlayer()
}

// MARK: - 研究用
/// userReversalWin の値をタスク後半（11~20回）の勝率として使用します。
/// あとでコード全体の変数名を変更したい
