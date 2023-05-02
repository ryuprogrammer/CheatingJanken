//
//  StageViewModel.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/04/07.
//

import Foundation

class StageViewModel: ObservableObject {
    // StageModelのインスタンス生成
    var stageModel = StageModel()

    @Published var stageSituations: [StageSituation] = []

    // イニシャライザ（インスタンス生成時に初期化）
    init() {
        stageSituations = stageModel.stageSituations
    }

    func playButtonSound() {
        stageModel.soundPlayer.soundPlay(soundName: .buttonSound)
    }
}
