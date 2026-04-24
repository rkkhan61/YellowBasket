import Foundation

struct StoreListing: Identifiable {
    let id: String          // storeId
    let storeName: String
    let address: String
    let distanceKm: Double
    let listings: [DiscountedItem]
}

struct DiscountedItem: Identifiable {
    let id: String          // listingId
    let ingredientName: String
    let category: String
    let originalPrice: Double
    let discountedPrice: Double
    let discountPercentage: Int
    let expiryDate: String  // "YYYY-MM-DD"
    let availableQuantity: Int
    let unit: String
}
