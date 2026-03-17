import Foundation

struct Recipe: Identifiable {
    let id: UUID
    let name: String
    let description: String
    let cookTime: String
    let emoji: String
}
