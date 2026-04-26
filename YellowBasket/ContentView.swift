import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var sessionManager: SessionManager
    @State private var showSplash = true

    var body: some View {
        if showSplash {
            SplashView()
                .task {
                    try? await Task.sleep(for: .seconds(2))
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showSplash = false
                    }
                }
        } else {
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
}

#Preview {
    ContentView()
        .environmentObject(SessionManager())
        .environment(AppState())
}
