import SwiftUI

struct ProfilePlaceholderView: View {

    var body: some View {
        VStack(spacing: 20) {

            Text("Profile")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("User profile features coming soon")
                .foregroundColor(.gray)

            Button(action: {
                do {
                    try AuthService.shared.logout()
                } catch {
                    print("Logout error:", error)
                }
            }) {
                Text("Log Out")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding(.top, 40)

        }
        .padding()
    }
}

#Preview {
    ProfilePlaceholderView()
}
