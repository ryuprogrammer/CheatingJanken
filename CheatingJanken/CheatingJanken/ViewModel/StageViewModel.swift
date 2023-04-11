//
//  StageViewModel.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/04/07.
//

import Foundation

struct StageViewModel {
    let stageSituations: [StageSituation] = [
        StageSituation(imageName: "001", winRate: 0.8),
        StageSituation(imageName: "002", winRate: 0.6),
        StageSituation(imageName: "003", winRate: 0.5),
        StageSituation(imageName: "004", winRate: 0.4),
        StageSituation(imageName: "005", winRate: 0.3),
        StageSituation(imageName: "006", winRate: 0.2),
        StageSituation(imageName: "007", winRate: 0.1)
    ]
}
