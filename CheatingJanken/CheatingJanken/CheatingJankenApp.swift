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
