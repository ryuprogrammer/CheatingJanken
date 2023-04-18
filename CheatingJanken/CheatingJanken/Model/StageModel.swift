//
//  StageModel.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/04/18.
//

import Foundation

class StageModel: ObservableObject {
    @Published var stageSituations: [StageSituation] = [
        StageSituation(imageName: "001", level: 1, winRate: 90, userReversalWin: nil, userReversalLose: nil),
        StageSituation(imageName: "002", level: 2, winRate: 60, userReversalWin: nil, userReversalLose: nil),
        StageSituation(imageName: "003", level: 3, winRate: 50, userReversalWin: 0.6, userReversalLose: nil),
        StageSituation(imageName: "004", level: 4, winRate: 40, userReversalWin: 0.5, userReversalLose: nil),
        StageSituation(imageName: "005", level: 5, winRate: 30, userReversalWin: 0.4, userReversalLose: nil),
        StageSituation(imageName: "006", level: 6, winRate: 50, userReversalWin: nil, userReversalLose: 0.6),
        StageSituation(imageName: "007", level: 7, winRate: 30, userReversalWin: nil, userReversalLose: 0.5)
    ]
}
