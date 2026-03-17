import SwiftUI

struct RecipeResultsView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(Color.brand.opacity(0.1))
                            .frame(width: 100, height: 100)
                        Image(systemName: "fork.knife")
                            .font(.system(size: 44))
                            .foregroundStyle(Color.brand)
                    }

                    VStack(spacing: 8) {
                        Text("Recipes")
                            .font(.title2.bold())
                        Text("Recipes matched to your scanned\ningredients will appear here.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }

                Spacer()
            }
            .navigationTitle("Recipes")
        }
    }
}

#Preview {
    RecipeResultsView()
}
