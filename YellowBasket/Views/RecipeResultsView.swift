import SwiftUI

struct RecipeResultsView: View {
    var ingredients: [Ingredient] = []

    var body: some View {
        if ingredients.isEmpty {
            placeholder
        } else {
            results
        }
    }

    // MARK: - Results

    private var results: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                VStack(alignment: .leading, spacing: 4) {
                    Text("\(MockDataService.recipes.count) recipes found")
                        .font(.title2.bold())
                    Text("Based on \(ingredients.count) confirmed ingredients")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 24)

                VStack(spacing: 12) {
                    ForEach(MockDataService.recipes) { recipe in
                        RecipeCard(recipe: recipe)
                    }
                }
                .padding(.horizontal, 24)
            }
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Placeholder (used as Recipes tab)

    private var placeholder: some View {
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

// MARK: - Recipe Card

private struct RecipeCard: View {
    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Text(recipe.emoji)
                    .font(.system(size: 32))
                    .frame(width: 52, height: 52)
                    .background(Color(.tertiarySystemBackground), in: RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 4) {
                    Text(recipe.name)
                        .font(.headline)
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption)
                        Text(recipe.cookTime)
                            .font(.caption)
                    }
                    .foregroundStyle(.secondary)
                }

                Spacer()
            }

            Text(recipe.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview("Results") {
    NavigationStack {
        RecipeResultsView(ingredients: MockDataService.detectedIngredients)
    }
}

#Preview("Placeholder") {
    NavigationStack {
        RecipeResultsView()
    }
}
