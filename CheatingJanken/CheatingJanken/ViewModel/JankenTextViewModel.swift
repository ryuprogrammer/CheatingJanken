//
//  JankenTextViewModel.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/04/12.
//

import Foundation

class JankenTextViewModel: ObservableObject {
    // JankenTextModelのインスタンス生成
    var jankenTextModel = JankenTextModel()
    // jankenTextをPublish
    @Published var jankenText = ""
    
    func makeJankenText(jankenCount: Int) {
        jankenText = jankenTextModel.jankenText(jankenCount: jankenCount)
    }
}
