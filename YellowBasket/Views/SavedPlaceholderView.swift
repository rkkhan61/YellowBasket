import SwiftUI

struct SavedView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        NavigationStack {
            Group {
                if appState.savedRecipes.isEmpty {
                    emptyState
                } else {
                    savedList
                }
            }
            .navigationTitle("Saved")
        }
    }

    // MARK: - Saved list

    private var savedList: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(appState.savedRecipes) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                        SavedRecipeCard(recipe: recipe)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
    }

    // MARK: - Empty state

    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()

            VStack(spacing: 16) {
                Text("🔖")
                    .font(.system(size: 56))

                VStack(spacing: 8) {
                    Text("No saved recipes yet")
                        .font(.title3.bold())
                    Text("Recipes you save will appear here.\nTap Save Recipe on any recipe to add it.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }

            Spacer()
        }
    }
}

// MARK: - Saved recipe card

private struct SavedRecipeCard: View {
    let recipe: Recipe

    var body: some View {
        HStack(spacing: 14) {
            Text(recipe.emoji)
                .font(.system(size: 30))
                .frame(width: 52, height: 52)
                .background(Color.brand.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                HStack(spacing: 10) {
                    Text("⏱️ \(recipe.cookTime)")
                    Text("📊 \(recipe.difficulty)")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color(.systemGray3))
        }
        .padding(14)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview("Empty") {
    SavedView()
        .environment(AppState())
}

#Preview("With recipes") {
    let state = AppState()
    state.savedRecipes = MockDataService.recipes
    return SavedView()
        .environment(state)
}
