import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            // Soft gradient background — warm at top, neutral below
            LinearGradient(
                colors: [Color.brand.opacity(0.10), Color(.systemBackground)],
                startPoint: .top,
                endPoint: .center
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Brand mark with concentric glow rings
                VStack(spacing: 18) {
                    ZStack {
                        Circle()
                            .fill(Color.brand.opacity(0.06))
                            .frame(width: 148, height: 148)
                        Circle()
                            .fill(Color.brand.opacity(0.10))
                            .frame(width: 110, height: 110)
                        Circle()
                            .fill(Color.brand.opacity(0.16))
                            .frame(width: 80, height: 80)
                        Image(systemName: "basket.fill")
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundStyle(Color.brand)
                    }

                    VStack(spacing: 6) {
                        Text("Yellow Basket")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                        Text("* Brand tagline and logo to be inserted later *")
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

                Spacer().frame(height: 16)

                // Error message
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)
                        .padding(.bottom, 8)
                }

                // Primary CTA
                Button {
                    Task { await viewModel.submit(email: email, password: password) }
                } label: {
                    Group {
                        if viewModel.isLoading {
                            ProgressView().tint(.black)
                        } else {
                            Text(viewModel.isSignUp ? "Create Account" : "Sign In")
                                .font(.headline)
                                .foregroundStyle(.black)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.brand, in: RoundedRectangle(cornerRadius: 14))
                }
                .buttonStyle(PressableButtonStyle())
                .disabled(viewModel.isLoading)
                .padding(.horizontal, 28)

                Spacer().frame(height: 14)

                // Mode toggle
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.isSignUp.toggle()
                        viewModel.errorMessage = nil
                    }
                } label: {
                    Text(viewModel.isSignUp ? "Already have an account? **Sign In**" : "Don't have an account? **Sign Up**")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)

                Spacer().frame(height: 28)

                // OR divider
                HStack(spacing: 12) {
                    Rectangle()
                        .fill(Color(.separator))
                        .frame(height: 1)
                    Text("OR")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                    Rectangle()
                        .fill(Color(.separator))
                        .frame(height: 1)
                }
                .padding(.horizontal, 28)

                Spacer().frame(height: 20)

                // Google Sign-In
                Button {
                    Task { await viewModel.signInWithGoogle() }
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "globe")
                            .font(.system(size: 17, weight: .medium))
                        Text("Continue with Google")
                            .font(.headline)
                    }
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(
                        Color(.secondarySystemBackground),
                        in: RoundedRectangle(cornerRadius: 14)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(.separator), lineWidth: 1)
                    )
                }
                .buttonStyle(PressableButtonStyle())
                .disabled(viewModel.isLoading)
                .padding(.horizontal, 28)

                Spacer()
            }
        }
    }
}

#Preview {
    LoginView()
}
