import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @Environment(AppState.self) private var appState

    private var isSaved: Bool {
        appState.savedRecipes.contains(where: { $0.id == recipe.id })
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                // MARK: Overview card
                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 14) {
                        Text(recipe.emoji)
                            .font(.system(size: 44))
                            .frame(width: 64, height: 64)
                            .background(Color.brand.opacity(0.1), in: RoundedRectangle(cornerRadius: 14))

                        VStack(alignment: .leading, spacing: 4) {
                            Text(recipe.name)
                                .font(.title3.bold())
                                .fixedSize(horizontal: false, vertical: true)
                            if !recipe.description.isEmpty {
                                Text(recipe.description)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }

                    Divider()

                    HStack(spacing: 0) {
                        MetaItem(emoji: "⏱️", value: recipe.cookTime, label: "Cook time")
                        Divider().frame(height: 32)
                        MetaItem(emoji: "📊", value: recipe.difficulty, label: "Difficulty")
                        Divider().frame(height: 32)
                        MetaItem(emoji: "🍽️", value: "\(recipe.servings)", label: "Servings")
                    }
                }
                .padding(18)
                .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 18))

                // MARK: Missing ingredients banner
                if !recipe.missingIngredients.isEmpty {
                    HStack(spacing: 12) {
                        Text("🛒")
                            .font(.title3)
                        VStack(alignment: .leading, spacing: 3) {
                            Text("You're missing \(recipe.missingIngredients.count) ingredient\(recipe.missingIngredients.count == 1 ? "" : "s")")
                                .font(.subheadline.bold())
                            Text(recipe.missingIngredients.joined(separator: " · "))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    .padding(14)
                    .background(Color.orange.opacity(0.1), in: RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.orange.opacity(0.25), lineWidth: 1))
                }

                // MARK: Ingredients card
                VStack(alignment: .leading, spacing: 0) {
                    Text("Ingredients")
                        .font(.headline)
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .padding(.bottom, 12)

                    Divider().padding(.horizontal, 16)

                    ForEach(recipe.ingredients, id: \.self) { ingredient in
                        let missing = recipe.missingIngredients.contains(ingredient)
                        HStack(spacing: 10) {
                            Circle()
                                .fill(missing ? Color.orange.opacity(0.6) : Color.brand.opacity(0.6))
                                .frame(width: 7, height: 7)
                            Text(ingredient)
                                .font(.subheadline)
                                .foregroundStyle(missing ? .secondary : .primary)
                            Spacer()
                            if missing {
                                Text("missing")
                                    .font(.caption2.weight(.semibold))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 7)
                                    .padding(.vertical, 3)
                                    .background(Color.orange, in: Capsule())
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 11)

                        if ingredient != recipe.ingredients.last {
                            Divider().padding(.leading, 33)
                        }
                    }
                    Spacer(minLength: 14)
                }
                .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 18))

                // MARK: Steps card
                if !recipe.steps.isEmpty {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Steps")
                            .font(.headline)
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                            .padding(.bottom, 12)

                        Divider().padding(.horizontal, 16)

                        ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                            HStack(alignment: .top, spacing: 14) {
                                Text("\(index + 1)")
                                    .font(.subheadline.bold())
                                    .foregroundStyle(Color.brand)
                                    .frame(width: 28, height: 28)
                                    .background(Color.brand.opacity(0.12), in: Circle())

                                Text(step)
                                    .font(.subheadline)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)

                            if index < recipe.steps.count - 1 {
                                Divider().padding(.leading, 58)
                            }
                        }
                        Spacer(minLength: 14)
                    }
                    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 18))
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 40)
        }
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            VStack(spacing: 0) {
                Divider()
                Button {
                    appState.savedRecipes.append(recipe)
                    appState.selectedTab = 2
                } label: {
                    HStack(spacing: 8) {
                        Text(isSaved ? "✓" : "🔖")
                        Text(isSaved ? "Saved" : "Save Recipe")
                            .font(.headline)
                    }
                    .foregroundStyle(isSaved ? Color(.systemGray) : .black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        isSaved ? Color(.systemGray5) : Color.brand,
                        in: RoundedRectangle(cornerRadius: 14)
                    )
                }
                .buttonStyle(PressableButtonStyle())
                .disabled(isSaved)
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
            .background(Color(.systemBackground))
        }
    }
}

// MARK: - Meta item

private struct MetaItem: View {
    let emoji: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 3) {
            Text(emoji)
                .font(.title3)
            Text(value)
                .font(.subheadline.bold())
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationStack {
        RecipeDetailView(recipe: MockDataService.recipes[0])
    }
}
