//
//  CheatingJankenApp.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/03/19.
//

import SwiftUI

@main
struct CheatingJankenApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            StageView()
        }
    }
}
