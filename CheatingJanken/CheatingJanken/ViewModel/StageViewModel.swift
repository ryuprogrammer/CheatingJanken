//
//  StageViewModel.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/04/07.
//

import Foundation

class StageViewModel: ObservableObject {
    @Published var stageSituations: [StageSituation] = [
        StageSituation(stage: "ネズミ", situation: true, winRate: 80),
        StageSituation(stage: "うさぎ", situation: true, winRate: 60),
        StageSituation(stage: "犬", situation: true, winRate: 50),
        StageSituation(stage: "ぞう", situation: false, winRate: 30),
        StageSituation(stage: "パンダ", situation: false, winRate: 20),
        StageSituation(stage: "人間", situation: false, winRate: 8),
        StageSituation(stage: "ロボット", situation: false, winRate: 2)
    ]
}
