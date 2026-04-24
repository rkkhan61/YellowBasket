import Foundation
import FirebaseAuth

final class SessionManager: ObservableObject {
    @Published var currentUser: FirebaseAuth.User?

    private var authStateHandle: AuthStateDidChangeListenerHandle?

    init() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.currentUser = user
        }
    }

    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    var isLoggedIn: Bool { currentUser != nil }

    func logout() {
        try? AuthService.shared.logout()
    }
}
