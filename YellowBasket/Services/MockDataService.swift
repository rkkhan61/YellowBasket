import Foundation

struct MockDataService {

    static let detectedIngredients: [Ingredient] = [
        Ingredient(id: UUID(), name: "Eggs",          emoji: "🥚", isSelected: true),
        Ingredient(id: UUID(), name: "Butter",        emoji: "🧈", isSelected: true),
        Ingredient(id: UUID(), name: "Milk",          emoji: "🥛", isSelected: true),
        Ingredient(id: UUID(), name: "Cheddar Cheese",emoji: "🧀", isSelected: true),
        Ingredient(id: UUID(), name: "Spinach",       emoji: "🥬", isSelected: true),
        Ingredient(id: UUID(), name: "Garlic",        emoji: "🧄", isSelected: true),
        Ingredient(id: UUID(), name: "Tomatoes",      emoji: "🍅", isSelected: false),
        Ingredient(id: UUID(), name: "Bell Pepper",   emoji: "🫑", isSelected: false),
    ]

    static let recipes: [Recipe] = [
        Recipe(
            id: UUID(),
            name: "Spinach & Cheese Omelette",
            description: "A fluffy omelette filled with wilted spinach and melted cheddar. Ready in minutes.",
            cookTime: "10 min",
            emoji: "🍳"
        ),
        Recipe(
            id: UUID(),
            name: "Garlic Butter Scrambled Eggs",
            description: "Creamy scrambled eggs cooked low and slow with fragrant garlic butter.",
            cookTime: "8 min",
            emoji: "🧄"
        ),
        Recipe(
            id: UUID(),
            name: "Cheesy Baked Eggs",
            description: "Eggs baked in a rich tomato-cheese sauce. Great for brunch or a light dinner.",
            cookTime: "20 min",
            emoji: "🧀"
        ),
        Recipe(
            id: UUID(),
            name: "Spinach & Egg Frittata",
            description: "Italian-style baked egg dish loaded with spinach, cheese, and roasted garlic.",
            cookTime: "25 min",
            emoji: "🥗"
        ),
    ]
}
