import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var sessionManager: SessionManager
    @AppStorage("appearanceMode") private var appearanceMode: Int = 0
    @State private var notificationsEnabled = true

    private var user: (name: String, email: String, provider: String) {
        let u = sessionManager.currentUser
        let name = u?.displayName ?? ""
        let email = u?.email ?? ""
        let isGoogle = u?.providerData.contains(where: { $0.providerID == "google.com" }) ?? false
        return (name, email, isGoogle ? "Google" : "Email")
    }

    var body: some View {
        NavigationStack {
            List {
                accountSection
                appearanceSection
                preferencesSection
                legalSection
                logoutSection
            }
            .safeAreaPadding(.bottom, AppLayout.tabBarContentClearance)
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
        }
    }

    // MARK: - Account

    private var accountSection: some View {
        Section("Account") {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color.brand.opacity(0.15))
                        .frame(width: 50, height: 50)
                    Text(initials)
                        .font(.title3.bold())
                        .foregroundStyle(Color.brand)
                }

                VStack(alignment: .leading, spacing: 3) {
                    if !user.name.isEmpty {
                        Text(user.name)
                            .font(.headline)
                    }
                    Text(user.email.isEmpty ? "No email" : user.email)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 6)

            LabeledContent("Sign-in method", value: user.provider)
        }
    }

    // MARK: - Appearance

    private var appearanceSection: some View {
        Section("Appearance") {
            Picker("Theme", selection: $appearanceMode) {
                Text("System").tag(0)
                Text("Light").tag(1)
                Text("Dark").tag(2)
            }
            .pickerStyle(.segmented)
            .padding(.vertical, 4)
        }
    }

    // MARK: - Preferences

    private var preferencesSection: some View {
        Section("Preferences") {
            Toggle("Notifications", isOn: $notificationsEnabled)
            LabeledContent("Location") {
                Text("Liverpool L6/L7")
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Legal

    private var legalSection: some View {
        Section("Legal") {
            NavigationLink("Privacy Policy", destination: LegalTextView(title: "Privacy Policy"))
            NavigationLink("Terms of Service", destination: LegalTextView(title: "Terms of Service"))
        }
    }

    // MARK: - Logout

    private var logoutSection: some View {
        Section {
            Button(role: .destructive) {
                sessionManager.logout()
            } label: {
                Text("Log Out")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .fontWeight(.semibold)
            }
        }
    }

    // MARK: - Helpers

    private var initials: String {
        let words = user.name.split(separator: " ")
        let letters = words.prefix(2).compactMap { $0.first.map(String.init) }
        if letters.isEmpty {
            return user.email.prefix(1).uppercased()
        }
        return letters.joined()
    }
}

// MARK: - Legal placeholder view

private struct LegalTextView: View {
    let title: String

    var body: some View {
        ScrollView {
            Text("Full \(title) content coming soon.")
                .font(.body)
                .foregroundStyle(.secondary)
                .padding(24)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SettingsView()
        .environmentObject(SessionManager())
        .environment(AppState())
}
