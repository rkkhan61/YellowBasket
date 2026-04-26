import SwiftUI

struct MainTabView: View {
    @Environment(AppState.self) private var appState
    @State private var showAddSheet = false
    @State private var showScanFlow = false

    var body: some View {
        @Bindable var appState = appState
        Group {
            switch appState.selectedTab {
            case 0:
                HomeView(showAddSheet: $showAddSheet)
            case 1:
                NavigationStack { RecipeResultsView() }
            case 2:
                SavedView()
            default:
                ProfilePlaceholderView()
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            CustomTabBar(selectedTab: $appState.selectedTab, onPlusTap: { showAddSheet = true })
                .background(Color(.systemBackground))
        }
        .sheet(isPresented: $showAddSheet) {
            AddIngredientsSheet(onImageScan: {
                showAddSheet = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    showScanFlow = true
                }
            })
        }
        .sheet(isPresented: $showScanFlow) {
            ScanView()
        }
    }
}

// MARK: - Custom tab bar

private struct CustomTabBar: View {
    @Binding var selectedTab: Int
    let onPlusTap: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            TabBarButton(emoji: "🏠", label: "Home",    selected: selectedTab == 0) { selectedTab = 0 }
            TabBarButton(emoji: "🍴", label: "Recipes", selected: selectedTab == 1) { selectedTab = 1 }

            // Center + button
            Button(action: onPlusTap) {
                ZStack {
                    Circle()
                        .fill(Color.brand)
                        .frame(width: 48, height: 48)
                        .shadow(color: Color.brand.opacity(0.3), radius: 6, x: 0, y: 2)
                    Text("+")
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundStyle(.black)
                }
            }
            .frame(maxWidth: .infinity)

            TabBarButton(emoji: "🔖", label: "Saved",   selected: selectedTab == 2) { selectedTab = 2 }
            TabBarButton(emoji: "👤", label: "Profile",  selected: selectedTab == 3) { selectedTab = 3 }
        }
        .padding(.top, 10)
        .padding(.bottom, 20)
        .overlay(Divider(), alignment: .top)
    }
}

private struct TabBarButton: View {
    let emoji: String
    let label: String
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(emoji)
                    .font(.system(size: 22))
                    .opacity(selected ? 1.0 : 0.4)
                Text(label)
                    .font(.caption2.weight(selected ? .semibold : .regular))
                    .foregroundStyle(selected ? Color.brand : Color(.systemGray))
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MainTabView()
        .environmentObject(SessionManager())
        .environment(AppState())
}
