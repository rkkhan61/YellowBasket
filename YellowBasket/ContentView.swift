import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var sessionManager: SessionManager

    var body: some View {
        Group {
            if sessionManager.isLoggedIn {
                MainTabView()
            } else {
                LoginView()
            }
        }
        .animation(.easeInOut(duration: 0.25), value: sessionManager.isLoggedIn)
    }
}

#Preview {
    ContentView()
        .environmentObject(SessionManager())
        .environment(AppState())
}
