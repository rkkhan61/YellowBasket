import SwiftUI

struct SavedPlaceholderView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(Color.brand.opacity(0.1))
                            .frame(width: 100, height: 100)
                        Image(systemName: "bookmark.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(Color.brand)
                    }

                    VStack(spacing: 8) {
                        Text("Saved Recipes")
                            .font(.title2.bold())
                        Text("Recipes you save will\nappear here.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }

                Spacer()
            }
            .navigationTitle("Saved")
        }
    }
}

#Preview {
    SavedPlaceholderView()
}
