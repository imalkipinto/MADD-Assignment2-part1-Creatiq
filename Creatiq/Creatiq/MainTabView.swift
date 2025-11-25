import SwiftUI

struct MainTabView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            NavigationStack {
                DashboardView(modelContext: modelContext)
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }

            NavigationStack {
                PostPlannerView(modelContext: modelContext)
            }
            .tabItem {
                Image(systemName: "calendar")
                Text("Planner")
            }

            NavigationStack {
                AICaptionGeneratorView()
            }
            .tabItem {
                Image(systemName: "sparkles")
                Text("AI")
            }

            NavigationStack {
                MoodboardView(modelContext: modelContext)
            }
            .tabItem {
                Image(systemName: "square.grid.2x2")
                Text("Moodboard")
            }

            NavigationStack {
                OutfitTrackerView(modelContext: modelContext)
            }
            .tabItem {
                Image(systemName: "hanger")
                Text("Outfits")
            }
        }
    }
}

#Preview {
    MainTabView()
}
