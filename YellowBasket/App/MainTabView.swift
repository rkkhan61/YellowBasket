import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(0)

            ScanView()
                .tabItem { Label("Scan", systemImage: "barcode.viewfinder") }
                .tag(1)

            NavigationStack {
                RecipeResultsView()
            }
            .tabItem { Label("Recipes", systemImage: "fork.knife") }
            .tag(2)

            SavedPlaceholderView()
                .tabItem { Label("Saved", systemImage: "bookmark.fill") }
                .tag(3)

            ProfilePlaceholderView()
                .tabItem { Label("Profile", systemImage: "person.fill") }
                .tag(4)
        }
        .tint(Color.brand)
    }
}

#Preview {
    MainTabView()
        .environment(AppState())
}
