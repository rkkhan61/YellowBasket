import SwiftUI

struct HomeView: View {
    @Binding var selectedTab: Int
    @EnvironmentObject private var sessionManager: SessionManager
    @StateObject private var viewModel = HomeViewModel()

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        default:      return "Good evening"
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    header
                        .padding(.horizontal, 20)
                        .padding(.top, 8)

                    searchBar
                        .padding(.horizontal, 20)
                        .padding(.top, 14)

                    if viewModel.isSearchActive {
                        searchResults
                            .padding(.top, 20)
                    } else {
                        scanHero
                            .padding(.top, 24)

                        impactStats
                            .padding(.top, 28)

                        categoryChips
                            .padding(.top, 28)

                        dealsNearby
                            .padding(.top, 28)

                        if !sessionManager.savedIngredients.isEmpty {
                            myIngredients
                                .padding(.top, 28)
                        }
                    }
                }
                .padding(.bottom, 36)
            }
            .scrollDismissesKeyboard(.immediately)
            .navigationTitle("YellowBasket")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 3) {
                Text(greeting)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("Your kitchen, sorted.")
                    .font(.title2.bold())
            }
            Spacer()
            HStack(spacing: 4) {
                Text("📍")
                    .font(.caption2)
                Text("Liverpool, L6")
                    .font(.caption.weight(.medium))
            }
            .foregroundStyle(Color.brand)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.brand.opacity(0.12), in: Capsule())
        }
    }

    // MARK: - Search bar

    @FocusState private var searchFocused: Bool

    private var searchBar: some View {
        HStack(spacing: 10) {
            Text("🔍")
                .font(.subheadline)
            TextField("Search ingredients, deals, stores...", text: $viewModel.searchText)
                .autocorrectionDisabled()
                .autocapitalization(.none)
                .focused($searchFocused)
                .onSubmit { searchFocused = false }
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") { searchFocused = false }
                    }
                }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Impact stats

    private var impactStats: some View {
        HStack(spacing: 10) {
            ImpactStatCard(value: "£12.40", label: "Saved", emoji: "💰")
            ImpactStatCard(value: "8", label: "Meals rescued", emoji: "🍽️")
            ImpactStatCard(value: "2.3kg", label: "CO₂ reduced", emoji: "🌿")
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Scan hero

    private var scanHero: some View {
        Button { selectedTab = 1 } label: {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Scan your kitchen")
                            .font(.title2.bold())
                            .foregroundStyle(.primary)
                        Text("Find recipes from what\nyou already have")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    HStack(spacing: 8) {
                        Text("📷")
                        Text("Start Scanning")
                            .font(.headline.bold())
                    }
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.brand, in: RoundedRectangle(cornerRadius: 14))
                }

                Text("📸")
                    .font(.system(size: 64))
                    .opacity(0.55)
            }
            .padding(22)
            .background(
                LinearGradient(
                    colors: [Color.brand.opacity(0.18), Color.brand.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: RoundedRectangle(cornerRadius: 20)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.brand.opacity(0.25), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 20)
    }

    // MARK: - Category chips

    private var categoryChips: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Browse by category")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(viewModel.categories, id: \.self) { category in
                        CategoryChip(
                            label: category,
                            isSelected: viewModel.selectedCategory == category
                        ) {
                            viewModel.toggleCategory(category)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }

    // MARK: - Deals near you

    private var dealsNearby: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Deals near you")
                    .font(.headline)
                Spacer()
                Text("\(viewModel.filteredDeals.count) items")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 20)

            if viewModel.filteredDeals.isEmpty {
                Text("No deals in this category yet.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 20)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 14) {
                        ForEach(viewModel.filteredDeals) { entry in
                            DealCard(entry: entry)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 4)
                }
            }
        }
    }

    // MARK: - Search results (vertical)

    private var searchResults: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(viewModel.filteredDeals.isEmpty ? "No results" : "\(viewModel.filteredDeals.count) result\(viewModel.filteredDeals.count == 1 ? "" : "s")")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 20)

            if viewModel.filteredDeals.isEmpty {
                Text("Try searching for an ingredient, category, or store.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 20)
            } else {
                VStack(spacing: 10) {
                    ForEach(viewModel.filteredDeals) { entry in
                        SearchDealRow(entry: entry)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }

    // MARK: - My ingredients

    private var myIngredients: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Your saved ingredients")
                    .font(.headline)
                Spacer()
                Button("Scan more") { selectedTab = 1 }
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Color.brand)
            }
            .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(sessionManager.savedIngredients) { ingredient in
                        HStack(spacing: 6) {
                            Text(ingredient.emoji)
                            Text(ingredient.name)
                                .font(.subheadline.weight(.medium))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.secondarySystemBackground), in: Capsule())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 4)
            }
        }
    }
}

// MARK: - Impact stat card

private struct ImpactStatCard: View {
    let value: String
    let label: String
    let emoji: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(emoji)
                .font(.title3)
            Text(value)
                .font(.title3.bold())
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Category chip

private struct CategoryChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(isSelected ? .black : .primary)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    isSelected ? Color.brand : Color(.secondarySystemBackground),
                    in: Capsule()
                )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}

// MARK: - Deal card (horizontal carousel)

private struct DealCard: View {
    let entry: DealEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Discount badge + quantity
            HStack {
                Text("-\(entry.item.discountPercentage)%")
                    .font(.caption.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.red, in: Capsule())
                Spacer()
                Text("\(entry.item.availableQuantity) left")
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 10)

            // Ingredient name + unit
            Text(emojiFor(entry.item.ingredientName))
                .font(.system(size: 28))
                .padding(.bottom, 4)

            Text(entry.item.ingredientName)
                .font(.subheadline.bold())
                .lineLimit(1)
            Text(entry.item.unit)
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.bottom, 10)

            Spacer()

            // Price
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("£\(String(format: "%.2f", entry.item.originalPrice))")
                    .font(.caption)
                    .foregroundStyle(Color(.tertiaryLabel))
                    .strikethrough()
                Text("£\(String(format: "%.2f", entry.item.discountedPrice))")
                    .font(.subheadline.bold())
                    .foregroundStyle(Color.brand)
            }
            .padding(.bottom, 6)

            // Store + distance
            HStack(spacing: 4) {
                Text("🏪")
                    .font(.caption2)
                Text(entry.store.storeName)
                    .font(.caption2.weight(.medium))
                    .lineLimit(1)
                Spacer()
                Text("\(String(format: "%.1f", entry.store.distanceKm))km")
                    .font(.caption2)
            }
            .foregroundStyle(.secondary)
            .padding(.bottom, 4)

            // Expiry
            HStack(spacing: 4) {
                Text("⏰")
                    .font(.caption2)
                Text(formatExpiry(entry.item.expiryDate))
                    .font(.caption2)
            }
            .foregroundStyle(.secondary)
        }
        .padding(14)
        .frame(width: 190, height: 220)
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 2)
    }

    private func formatExpiry(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else { return dateString }
        formatter.dateFormat = "d MMM"
        return "Expires \(formatter.string(from: date))"
    }

    private func emojiFor(_ name: String) -> String {
        let map: [String: String] = [
            "Onions": "🧅", "Mushrooms": "🍄", "Tomatoes": "🍅",
            "Cheddar Cheese": "🧀", "Chives": "🌿", "Spinach": "🥬",
            "Milk": "🥛", "Eggs": "🥚", "Butter": "🧈",
            "Bell Pepper": "🫑", "Garlic": "🧄"
        ]
        return map[name] ?? "🛒"
    }
}

// MARK: - Search result row (vertical list)

private struct SearchDealRow: View {
    let entry: DealEntry

    var body: some View {
        HStack(spacing: 14) {
            // Category colour dot
            Circle()
                .fill(Color.brand.opacity(0.15))
                .frame(width: 44, height: 44)
                .overlay(
                    Text(emojiFor(entry.item.ingredientName))
                        .font(.title3)
                )

            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(entry.item.ingredientName)
                        .font(.subheadline.bold())
                    Spacer()
                    Text("-\(entry.item.discountPercentage)%")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(Color.red, in: Capsule())
                }
                Text(entry.store.storeName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                HStack(spacing: 8) {
                    Text("£\(String(format: "%.2f", entry.item.discountedPrice))")
                        .font(.caption.bold())
                        .foregroundStyle(Color.brand)
                    Text("£\(String(format: "%.2f", entry.item.originalPrice))")
                        .font(.caption)
                        .foregroundStyle(Color(.tertiaryLabel))
                        .strikethrough()
                    Spacer()
                    Text("\(String(format: "%.1f", entry.store.distanceKm))km")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14))
    }

    private func emojiFor(_ name: String) -> String {
        let map: [String: String] = [
            "Onions": "🧅", "Mushrooms": "🍄", "Tomatoes": "🍅",
            "Cheddar Cheese": "🧀", "Chives": "🌿", "Spinach": "🥬",
            "Milk": "🥛", "Eggs": "🥚", "Butter": "🧈",
            "Bell Pepper": "🫑", "Garlic": "🧄"
        ]
        return map[name] ?? "🛒"
    }
}

// MARK: - Preview

#Preview {
    HomeView(selectedTab: .constant(0))
        .environmentObject(SessionManager())
}
