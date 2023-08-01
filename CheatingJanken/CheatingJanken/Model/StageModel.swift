//
//  StageModel.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/04/18.
//

import Foundation
import AVFoundation

struct StageModel {
    let stageSituations: [StageSituation] = [
        // タスク１: 基準（勝率の変化なし。常に勝率50%）
        StageSituation(imageName: "001", level: 1, winRate: 50, userReversalWin: nil, userReversalLose: nil),
        // タスク２: 30%
        StageSituation(imageName: "002", level: 2, winRate: 30, userReversalWin: nil, userReversalLose: nil),
        // タスク３: 60%
        StageSituation(imageName: "003", level: 3, winRate: 60, userReversalWin: nil, userReversalLose: nil),
        // タスク４: 30% → 60%
        StageSituation(imageName: "004", level: 4, winRate: 30, userReversalWin: 0.5, userReversalLose: nil),
        // タスク５: 60% → 30%
        StageSituation(imageName: "005", level: 5, winRate: 60, userReversalWin: 0.4, userReversalLose: nil),
        // タスク６: 0%
        StageSituation(imageName: "006", level: 6, winRate: 0, userReversalWin: nil, userReversalLose: 0.6),
        // タスク７: 100%
        StageSituation(imageName: "007", level: 7, winRate: 100, userReversalWin: nil, userReversalLose: 0.5)
    ]
    // soundPlayerのインスタンス生成
    var soundPlayer = SoundPlayer()
}
