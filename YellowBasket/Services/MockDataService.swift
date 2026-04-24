import Foundation

struct MockDataService {

    // MARK: - Ingredients

    // High confidence (≥ 0.9) → auto-confirmed; low confidence (< 0.9) → flagged for review
    static let detectedIngredients: [Ingredient] = [
        Ingredient(id: UUID(), name: "Eggs",           emoji: "🥚", isSelected: true,  confidence: 0.97),
        Ingredient(id: UUID(), name: "Butter",         emoji: "🧈", isSelected: true,  confidence: 0.95),
        Ingredient(id: UUID(), name: "Milk",           emoji: "🥛", isSelected: true,  confidence: 0.93),
        Ingredient(id: UUID(), name: "Cheddar Cheese", emoji: "🧀", isSelected: true,  confidence: 0.91),
        Ingredient(id: UUID(), name: "Spinach",        emoji: "🥬", isSelected: true,  confidence: 0.96),
        Ingredient(id: UUID(), name: "Garlic",         emoji: "🧄", isSelected: true,  confidence: 0.94),
        Ingredient(id: UUID(), name: "Tomatoes",       emoji: "🍅", isSelected: false, confidence: 0.72),
        Ingredient(id: UUID(), name: "Bell Pepper",    emoji: "🫑", isSelected: false, confidence: 0.68),
    ]

    // MARK: - Recipes

    static let recipes: [Recipe] = [
        Recipe(
            id: UUID(),
            name: "Spinach & Cheese Omelette",
            emoji: "🍳",
            description: "A fluffy omelette filled with wilted spinach and melted cheddar. Ready in minutes.",
            cookTime: "10 min",
            difficulty: "Easy",
            servings: 1,
            ingredients: ["Eggs", "Butter", "Cheddar Cheese", "Spinach", "Onions", "Salt", "Pepper"],
            missingIngredients: ["Onions"],
            steps: [
                "Crack 3 eggs into a bowl, season with salt and pepper, and whisk until combined.",
                "Melt butter in a non-stick pan over medium heat.",
                "Add spinach to the pan and sauté for 1–2 minutes until wilted. Remove and set aside.",
                "Pour the egg mixture into the pan and tilt to spread evenly.",
                "When the edges begin to set, scatter cheddar cheese and wilted spinach over one half.",
                "Fold the omelette in half over the filling and slide onto a plate. Serve immediately."
            ]
        ),
        Recipe(
            id: UUID(),
            name: "Garlic Butter Scrambled Eggs",
            emoji: "🧄",
            description: "Creamy scrambled eggs cooked low and slow with fragrant garlic butter.",
            cookTime: "8 min",
            difficulty: "Easy",
            servings: 2,
            ingredients: ["Eggs", "Butter", "Garlic", "Milk", "Chives", "Salt", "Pepper"],
            missingIngredients: ["Chives"],
            steps: [
                "Mince 2 garlic cloves finely.",
                "Crack 4 eggs into a bowl, add a splash of milk, season with salt and pepper, and whisk.",
                "Melt butter in a pan over low heat, then add garlic and cook for 30 seconds until fragrant.",
                "Pour in the egg mixture. Using a spatula, fold the eggs slowly, moving them constantly.",
                "Remove from heat while eggs are still slightly underdone — residual heat will finish them.",
                "Transfer to plates and garnish with chopped chives."
            ]
        ),
        Recipe(
            id: UUID(),
            name: "Cheesy Baked Eggs",
            emoji: "🧀",
            description: "Eggs baked in a rich tomato-cheese sauce. Great for brunch or a light dinner.",
            cookTime: "20 min",
            difficulty: "Medium",
            servings: 2,
            ingredients: ["Eggs", "Cheddar Cheese", "Tomatoes", "Onions", "Garlic", "Butter", "Salt", "Pepper"],
            missingIngredients: ["Tomatoes", "Onions"],
            steps: [
                "Preheat oven to 190°C (375°F).",
                "Dice onions and tomatoes. Mince garlic.",
                "Melt butter in an oven-safe skillet over medium heat. Add onions and garlic, cook for 3 minutes.",
                "Add diced tomatoes, season with salt and pepper, and simmer for 5 minutes.",
                "Make 4 wells in the sauce and crack an egg into each.",
                "Scatter cheddar cheese over the top.",
                "Transfer to the oven and bake for 8–10 minutes until whites are set but yolks are still runny.",
                "Serve straight from the pan with crusty bread."
            ]
        ),
        Recipe(
            id: UUID(),
            name: "Spinach & Egg Frittata",
            emoji: "🥗",
            description: "Italian-style baked egg dish loaded with spinach, cheese, and roasted garlic.",
            cookTime: "25 min",
            difficulty: "Medium",
            servings: 4,
            ingredients: ["Eggs", "Spinach", "Cheddar Cheese", "Garlic", "Milk", "Onions", "Mushrooms", "Butter", "Salt", "Pepper"],
            missingIngredients: ["Onions", "Mushrooms"],
            steps: [
                "Preheat oven to 180°C (350°F).",
                "Slice mushrooms and dice onions. Mince garlic.",
                "In a large bowl, whisk together 6 eggs and a splash of milk. Season with salt and pepper.",
                "Melt butter in an oven-safe skillet over medium heat. Cook onions and mushrooms for 4 minutes.",
                "Add garlic and spinach, cooking until spinach wilts, about 2 minutes.",
                "Pour the egg mixture over the vegetables. Sprinkle cheddar cheese on top.",
                "Cook on the stovetop for 2 minutes until the edges start to set.",
                "Transfer to the oven and bake for 10–12 minutes until the centre is firm.",
                "Slice into wedges and serve warm or at room temperature."
            ]
        ),
    ]

    // MARK: - Store Listings

    static let storeListings: [StoreListing] = [
        StoreListing(
            id: "store_001",
            storeName: "GreenMart Edge Lane",
            address: "34 Edge Lane, Liverpool L7 2PE",
            distanceKm: 0.6,
            listings: [
                DiscountedItem(
                    id: "item_001",
                    ingredientName: "Onions",
                    category: "Vegetables",
                    originalPrice: 1.20,
                    discountedPrice: 0.40,
                    discountPercentage: 67,
                    expiryDate: "2026-04-26",
                    availableQuantity: 12,
                    unit: "bag (500g)"
                ),
                DiscountedItem(
                    id: "item_002",
                    ingredientName: "Mushrooms",
                    category: "Vegetables",
                    originalPrice: 1.80,
                    discountedPrice: 0.60,
                    discountPercentage: 67,
                    expiryDate: "2026-04-25",
                    availableQuantity: 8,
                    unit: "pack (250g)"
                ),
                DiscountedItem(
                    id: "item_003",
                    ingredientName: "Tomatoes",
                    category: "Vegetables",
                    originalPrice: 1.50,
                    discountedPrice: 0.55,
                    discountPercentage: 63,
                    expiryDate: "2026-04-26",
                    availableQuantity: 15,
                    unit: "pack (6 count)"
                ),
                DiscountedItem(
                    id: "item_004",
                    ingredientName: "Cheddar Cheese",
                    category: "Dairy",
                    originalPrice: 3.20,
                    discountedPrice: 1.60,
                    discountPercentage: 50,
                    expiryDate: "2026-04-28",
                    availableQuantity: 5,
                    unit: "block (400g)"
                ),
            ]
        ),
        StoreListing(
            id: "store_002",
            storeName: "FreshStop Kensington",
            address: "112 Kensington, Liverpool L6 3BJ",
            distanceKm: 1.2,
            listings: [
                DiscountedItem(
                    id: "item_005",
                    ingredientName: "Chives",
                    category: "Herbs",
                    originalPrice: 0.90,
                    discountedPrice: 0.30,
                    discountPercentage: 67,
                    expiryDate: "2026-04-25",
                    availableQuantity: 20,
                    unit: "bunch"
                ),
                DiscountedItem(
                    id: "item_006",
                    ingredientName: "Spinach",
                    category: "Vegetables",
                    originalPrice: 1.40,
                    discountedPrice: 0.50,
                    discountPercentage: 64,
                    expiryDate: "2026-04-25",
                    availableQuantity: 10,
                    unit: "bag (200g)"
                ),
                DiscountedItem(
                    id: "item_007",
                    ingredientName: "Milk",
                    category: "Dairy",
                    originalPrice: 1.10,
                    discountedPrice: 0.45,
                    discountPercentage: 59,
                    expiryDate: "2026-04-26",
                    availableQuantity: 7,
                    unit: "bottle (1L)"
                ),
                DiscountedItem(
                    id: "item_008",
                    ingredientName: "Eggs",
                    category: "Dairy & Eggs",
                    originalPrice: 2.50,
                    discountedPrice: 1.00,
                    discountPercentage: 60,
                    expiryDate: "2026-04-29",
                    availableQuantity: 6,
                    unit: "box (6 large)"
                ),
            ]
        ),
        StoreListing(
            id: "store_003",
            storeName: "Surplus & Co. Wavertree",
            address: "61 Picton Road, Liverpool L15 4LH",
            distanceKm: 2.3,
            listings: [
                DiscountedItem(
                    id: "item_009",
                    ingredientName: "Onions",
                    category: "Vegetables",
                    originalPrice: 0.80,
                    discountedPrice: 0.25,
                    discountPercentage: 69,
                    expiryDate: "2026-04-27",
                    availableQuantity: 25,
                    unit: "single (large)"
                ),
                DiscountedItem(
                    id: "item_010",
                    ingredientName: "Butter",
                    category: "Dairy",
                    originalPrice: 1.80,
                    discountedPrice: 0.90,
                    discountPercentage: 50,
                    expiryDate: "2026-05-01",
                    availableQuantity: 9,
                    unit: "block (250g)"
                ),
                DiscountedItem(
                    id: "item_011",
                    ingredientName: "Bell Pepper",
                    category: "Vegetables",
                    originalPrice: 1.20,
                    discountedPrice: 0.40,
                    discountPercentage: 67,
                    expiryDate: "2026-04-26",
                    availableQuantity: 14,
                    unit: "single"
                ),
                DiscountedItem(
                    id: "item_012",
                    ingredientName: "Garlic",
                    category: "Vegetables",
                    originalPrice: 0.60,
                    discountedPrice: 0.20,
                    discountPercentage: 67,
                    expiryDate: "2026-05-03",
                    availableQuantity: 30,
                    unit: "bulb"
                ),
                DiscountedItem(
                    id: "item_013",
                    ingredientName: "Mushrooms",
                    category: "Vegetables",
                    originalPrice: 2.00,
                    discountedPrice: 0.70,
                    discountPercentage: 65,
                    expiryDate: "2026-04-25",
                    availableQuantity: 4,
                    unit: "pack (400g)"
                ),
            ]
        ),
    ]
}
