import Foundation
import FirebaseAuth

final class SessionManager: ObservableObject {
    @Published var currentUser: FirebaseAuth.User?
    @Published var savedIngredients: [Ingredient] = []

    private var authStateHandle: AuthStateDidChangeListenerHandle?

    init() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.currentUser = user
            if let user {
                Task { [weak self] in
                    let ingredients = await FirestoreService.shared.fetchIngredients(userId: user.uid)
                    await MainActor.run { self?.savedIngredients = ingredients }
                }
            } else {
                self?.savedIngredients = []
            }
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
