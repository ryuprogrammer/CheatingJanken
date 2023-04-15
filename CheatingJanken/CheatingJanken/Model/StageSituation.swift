//
//  StageName.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/04/07.
//

import Foundation

struct StageSituation: Identifiable, Hashable {
    let id: UUID = UUID()
    let imageName: String
    // 難易度
    var level: Int
    // 初期の勝率
    let winRate: Int
    // ユーザーが逆転勝利する閾値
    let userReversalWin: Double?
    // ユーザーが逆転まけする閾値
    let userReversalLose: Double?
}
