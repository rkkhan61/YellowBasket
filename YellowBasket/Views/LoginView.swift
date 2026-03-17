import SwiftUI

struct LoginView: View {
    @Environment(AppState.self) private var appState
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Brand mark
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.brand.opacity(0.12))
                            .frame(width: 88, height: 88)
                        Image(systemName: "basket.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(Color.brand)
                    }

                    VStack(spacing: 6) {
                        Text("YellowBasket")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                        Text("Cook smarter. Waste less.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer().frame(height: 52)

                // Input fields
                VStack(spacing: 12) {
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .padding(.horizontal, 16)
                        .padding(.vertical, 15)
                        .background(
                            Color(.secondarySystemBackground),
                            in: RoundedRectangle(cornerRadius: 12)
                        )

                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 15)
                        .background(
                            Color(.secondarySystemBackground),
                            in: RoundedRectangle(cornerRadius: 12)
                        )
                }
                .padding(.horizontal, 28)

                Spacer().frame(height: 24)

                // Sign in
                Button {
                    appState.isLoggedIn = true
                } label: {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.brand, in: RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal, 28)

                Spacer().frame(height: 16)

                Text("Demo mode — any credentials work")
                    .font(.caption)
                    .foregroundStyle(Color(.tertiaryLabel))

                Spacer()
            }
        }
    }
}

#Preview {
    LoginView()
        .environment(AppState())
}
