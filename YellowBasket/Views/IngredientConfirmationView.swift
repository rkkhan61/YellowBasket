import SwiftUI

struct IngredientConfirmationView: View {
    @StateObject private var viewModel = IngredientConfirmationViewModel()

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
                    ForEach($viewModel.ingredients) { $ingredient in
                        IngredientRow(ingredient: $ingredient)
                        if ingredient.id != viewModel.ingredients.last?.id {
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
                        Task { await viewModel.confirmAndFindRecipes() }
                    } label: {
                        ZStack {
                            Text("Find Recipes")
                                .font(.headline)
                                .opacity(viewModel.isFinding ? 0 : 1)

                            HStack(spacing: 8) {
                                ProgressView()
                                    .tint(.black)
                                    .scaleEffect(0.85)
                                Text("Finding recipes...")
                                    .font(.headline)
                            }
                            .opacity(viewModel.isFinding ? 1 : 0)
                        }
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            viewModel.confirmedIngredients.isEmpty ? Color(.systemGray4) : Color.brand,
                            in: RoundedRectangle(cornerRadius: 14)
                        )
                    }
                    .buttonStyle(PressableButtonStyle())
                    .disabled(viewModel.confirmedIngredients.isEmpty || viewModel.isFinding)

                    Text("\(viewModel.confirmedIngredients.count) of \(viewModel.ingredients.count) selected")
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
        .navigationDestination(isPresented: $viewModel.showRecipes) {
            RecipeResultsView(ingredients: viewModel.confirmedIngredients)
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
                    .animation(.easeInOut(duration: 0.15), value: ingredient.isSelected)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .buttonStyle(PressableButtonStyle())
    }
}

#Preview {
    NavigationStack {
        IngredientConfirmationView()
    }
}
