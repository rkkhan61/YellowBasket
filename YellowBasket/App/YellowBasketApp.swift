import SwiftUI
import FirebaseCore

@main
struct YellowBasketApp: App {
    @AppStorage("appearanceMode") private var appearanceMode: Int = 0
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
                .preferredColorScheme(appColorScheme)
        }
    }

    private var appColorScheme: ColorScheme? {
        switch appearanceMode {
        case 1:
            return .light
        case 2:
            return .dark
        default:
            return nil
        }
    }
}
