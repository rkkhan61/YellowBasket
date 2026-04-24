import Foundation
import UIKit
import FirebaseAuth
import GoogleSignIn

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

    // MARK: - Google Sign-In
    @MainActor
    func signInWithGoogle() async throws {
        guard let rootVC = rootViewController() else {
            throw AuthServiceError.missingRootViewController
        }
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootVC)
        guard let idToken = result.user.idToken?.tokenString else {
            throw AuthServiceError.missingToken
        }
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: result.user.accessToken.tokenString
        )
        try await Auth.auth().signIn(with: credential)
    }

    @MainActor
    private func rootViewController() -> UIViewController? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
            .flatMap { $0.windows.first(where: \.isKeyWindow) }?
            .rootViewController
    }
}

enum AuthServiceError: LocalizedError {
    case missingRootViewController
    case missingToken

    var errorDescription: String? {
        switch self {
        case .missingRootViewController: return "Unable to present sign-in screen."
        case .missingToken: return "Google Sign-In did not return a valid token."
        }
    }
}
