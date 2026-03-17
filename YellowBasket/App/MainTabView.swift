import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }

            ScanView()
                .tabItem { Label("Scan", systemImage: "barcode.viewfinder") }

            RecipeResultsView()
                .tabItem { Label("Recipes", systemImage: "fork.knife") }

            SavedPlaceholderView()
                .tabItem { Label("Saved", systemImage: "bookmark.fill") }

            ProfilePlaceholderView()
                .tabItem { Label("Profile", systemImage: "person.fill") }
        }
        .tint(Color.brand)
    }
}

#Preview {
    MainTabView()
        .environment(AppState())
}
