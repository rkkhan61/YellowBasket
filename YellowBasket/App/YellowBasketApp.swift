import SwiftUI
import FirebaseCore

@main
struct YellowBasketApp: App {
    @State private var appState = AppState()
    @StateObject private var sessionManager = SessionManager()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
                .environmentObject(sessionManager)
        }
    }
}
