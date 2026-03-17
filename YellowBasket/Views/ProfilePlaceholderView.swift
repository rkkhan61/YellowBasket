import SwiftUI

struct ProfilePlaceholderView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(Color.brand.opacity(0.1))
                            .frame(width: 100, height: 100)
                        Image(systemName: "person.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(Color.brand)
                    }

                    VStack(spacing: 8) {
                        Text("Profile")
                            .font(.title2.bold())
                        Text("Your account details and\npreferences live here.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }

                Spacer()

                Button {
                    appState.isLoggedIn = false
                } label: {
                    Text("Sign Out")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.bottom, 32)
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfilePlaceholderView()
        .environment(AppState())
}
