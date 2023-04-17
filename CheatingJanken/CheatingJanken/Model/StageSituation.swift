//
//  StageName.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/04/07.
//

import Foundation

struct StageSituation: Identifiable, Hashable {
    let id: UUID = UUID()
    // キャラクターの写真
    let imageName: String
    // 難易度
    var level: Int
    // 初期の勝率
    let winRate: Int
    // ユーザーが逆転勝利する閾値
    let userReversalWin: Double?
    // ユーザーが逆転負けする閾値
    let userReversalLose: Double?
}
