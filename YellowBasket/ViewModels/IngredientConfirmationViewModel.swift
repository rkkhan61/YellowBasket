import Foundation
import FirebaseAuth

@MainActor
final class IngredientConfirmationViewModel: ObservableObject {
    @Published var ingredients: [Ingredient]
    @Published var isFinding = false
    @Published var showRecipes = false
    @Published var generatedRecipes: [Recipe] = []
    @Published var recipeError: String?

    var confirmedIngredients: [Ingredient] {
        ingredients.filter { $0.isSelected }
    }

    init(ingredients: [Ingredient]) {
        self.ingredients = ingredients
    }

    func confirmAndFindRecipes() async {
        guard !confirmedIngredients.isEmpty else { return }
        isFinding = true

        // Save to Firestore in the background — never block navigation on this
        let toSave = confirmedIngredients
        if let userId = Auth.auth().currentUser?.uid {
            Task {
                await FirestoreService.shared.saveIngredients(toSave, userId: userId)
            }
        }

        generatedRecipes = await GeminiRecipeService.shared.generateRecipes(from: toSave)
        if generatedRecipes.isEmpty {
            recipeError = "Couldn't generate recipes. Please try again."
        }
        isFinding = false
        showRecipes = true
    }
}
