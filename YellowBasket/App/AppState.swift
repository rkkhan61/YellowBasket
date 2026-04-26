import SwiftUI
import Observation

@Observable
final class AppState {
    var savedRecipes: [Recipe] = []
    var selectedTab: Int = 0
    var dismissScanFlow: Bool = false
}

extension Color {
    static let brand = Color(red: 0.98, green: 0.72, blue: 0.06)
}

// Shared button style — subtle scale + opacity on press
struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.88 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
