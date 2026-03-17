import SwiftUI

struct IngredientConfirmationView: View {
    @State private var ingredients = MockDataService.detectedIngredients
    @State private var showRecipes = false

    private var confirmedIngredients: [Ingredient] {
        ingredients.filter { $0.isSelected }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // Header
                VStack(alignment: .leading, spacing: 6) {
                    Text("Detected Ingredients")
                        .font(.title2.bold())
                    Text("Deselect anything that isn't an ingredient.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 24)

                // Ingredient list
                VStack(spacing: 0) {
                    ForEach($ingredients) { $ingredient in
                        IngredientRow(ingredient: $ingredient)
                        if ingredient.id != ingredients.last?.id {
                            Divider()
                                .padding(.leading, 58)
                        }
                    }
                }
                .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 24)

                // CTA
                VStack(spacing: 10) {
                    Button {
                        showRecipes = true
                    } label: {
                        Text("Find Recipes")
                            .font(.headline)
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                confirmedIngredients.isEmpty ? Color(.systemGray4) : Color.brand,
                                in: RoundedRectangle(cornerRadius: 14)
                            )
                    }
                    .disabled(confirmedIngredients.isEmpty)

                    Text("\(confirmedIngredients.count) of \(ingredients.count) selected")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 24)
            }
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .navigationTitle("Confirm")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showRecipes) {
            RecipeResultsView(ingredients: confirmedIngredients)
        }
    }
}

// MARK: - Row

private struct IngredientRow: View {
    @Binding var ingredient: Ingredient

    var body: some View {
        Button {
            ingredient.isSelected.toggle()
        } label: {
            HStack(spacing: 14) {
                Text(ingredient.emoji)
                    .font(.title2)
                    .frame(width: 36)

                Text(ingredient.name)
                    .font(.body)
                    .foregroundStyle(.primary)

                Spacer()

                Image(systemName: ingredient.isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(ingredient.isSelected ? Color.brand : Color(.systemGray3))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
    }
}

#Preview {
    NavigationStack {
        IngredientConfirmationView()
    }
}
