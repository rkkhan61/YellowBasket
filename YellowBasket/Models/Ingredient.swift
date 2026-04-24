import Foundation

struct Ingredient: Identifiable, Hashable {
    let id: UUID
    let name: String
    let emoji: String
    var isSelected: Bool
    var confidence: Double  // 0–1; >= 0.9 auto-confirmed, < 0.9 flagged for review
}
