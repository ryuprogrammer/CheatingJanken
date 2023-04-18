//
//  StageViewModel.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/04/07.
//

import Foundation

class StageViewModel: ObservableObject {
    let stageModel = StageModel()
    @Published var stageSituations: [StageSituation] = []

    init() {
        stageSituations = stageModel.stageSituations
    }
}
