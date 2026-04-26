import Foundation
import FirebaseFirestore

final class FirestoreService {
    static let shared = FirestoreService()
    private init() {}

    private let db = Firestore.firestore()

    // MARK: - Ingredients

    /// Saves the user's confirmed ingredients to Firestore.
    /// Stored as an array of dicts at users/{userId}.ingredients
    func saveIngredients(_ ingredients: [Ingredient], userId: String) async {
        let data: [[String: Any]] = ingredients.map { [
            "name": $0.name,
            "emoji": $0.emoji,
            "category": $0.category,
            "confidence": $0.confidence
        ]}
        do {
            try await db.collection("users").document(userId)
                .setData(["ingredients": data], merge: true)
        } catch {
            print("[FirestoreService] saveIngredients error:", error.localizedDescription)
        }
    }

    /// Fetches the user's saved ingredients from Firestore.
    /// Returns an empty array on failure or missing data.
    func fetchIngredients(userId: String) async -> [Ingredient] {
        do {
            let doc = try await db.collection("users").document(userId).getDocument()
            guard let array = doc.data()?["ingredients"] as? [[String: Any]] else { return [] }
            return array.compactMap { dict in
                guard
                    let name       = dict["name"]       as? String,
                    let emoji      = dict["emoji"]      as? String,
                    let confidence = dict["confidence"] as? Double
                else { return nil }
                let category = dict["category"] as? String ?? "Other"
                return Ingredient(id: UUID(), name: name, emoji: emoji, category: category, isSelected: true, confidence: confidence)
            }
        } catch {
            print("[FirestoreService] fetchIngredients error:", error.localizedDescription)
            return []
        }
    }
}
