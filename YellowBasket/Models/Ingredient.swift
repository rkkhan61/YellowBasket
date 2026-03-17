import Foundation

struct Ingredient: Identifiable, Hashable {
    let id: UUID
    let name: String
    let emoji: String
    var isSelected: Bool
}
