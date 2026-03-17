import SwiftUI
import Observation

@Observable
final class AppState {
    var isLoggedIn = false
}

extension Color {
    static let brand = Color(red: 0.98, green: 0.72, blue: 0.06)
}
