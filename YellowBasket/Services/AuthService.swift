import Foundation
import FirebaseAuth

final class AuthService {
    static let shared = AuthService()
    private init() {}

    var currentUser: FirebaseAuth.User? {
        Auth.auth().currentUser
    }

    func signUp(email: String, password: String) async throws {
        try await Auth.auth().createUser(withEmail: email, password: password)
    }

    func login(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }

    func logout() throws {
        try Auth.auth().signOut()
    }

    // MARK: - Google Sign-In (stub — wire up GoogleSignIn SDK here)
    func signInWithGoogle() async throws {
        // TODO: present Google Sign-In flow and exchange credential with Firebase
    }
}
