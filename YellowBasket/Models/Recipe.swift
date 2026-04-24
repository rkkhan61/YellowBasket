import Foundation

struct Recipe: Identifiable {
    let id: UUID
    let name: String
    let emoji: String
    let description: String     // Short subtitle shown on recipe cards
    let cookTime: String
    let difficulty: String      // "Easy", "Medium", "Hard"
    let servings: Int
    let ingredients: [String]   // Full ingredient list for the recipe
    let missingIngredients: [String]  // Ingredients not in the user's confirmed list
    let steps: [String]         // Ordered cooking instructions
}
