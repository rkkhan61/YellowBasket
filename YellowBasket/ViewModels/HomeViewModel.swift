import Foundation

struct DealEntry: Identifiable {
    var id: String { item.id }
    let store: StoreListing
    let item: DiscountedItem
}

final class HomeViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var selectedCategory: String? = nil

    let categories = ["Vegetables", "Dairy", "Herbs", "Pantry", "Bakery"]

    private let allDeals: [DealEntry] = MockDataService.storeListings.flatMap { store in
        store.listings.map { DealEntry(store: store, item: $0) }
    }

    var filteredDeals: [DealEntry] {
        var deals = allDeals
        if let cat = selectedCategory {
            deals = deals.filter { $0.item.category == cat }
        }
        if !searchText.isEmpty {
            let q = searchText
            deals = deals.filter {
                $0.item.ingredientName.localizedCaseInsensitiveContains(q) ||
                $0.item.category.localizedCaseInsensitiveContains(q) ||
                $0.store.storeName.localizedCaseInsensitiveContains(q)
            }
        }
        return deals
    }

    var isSearchActive: Bool { !searchText.isEmpty }

    func toggleCategory(_ category: String) {
        selectedCategory = selectedCategory == category ? nil : category
    }
}
