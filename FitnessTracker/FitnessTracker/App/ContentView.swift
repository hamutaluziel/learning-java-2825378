import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settings: AppSettings
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label(L.dashboard, systemImage: "house.fill")
                }
                .tag(0)

            WorkoutView()
                .tabItem {
                    Label(L.workouts, systemImage: "figure.run")
                }
                .tag(1)

            NutritionView()
                .tabItem {
                    Label(L.nutrition, systemImage: "fork.knife")
                }
                .tag(2)

            CallisthenicsView()
                .tabItem {
                    Label(L.training, systemImage: "figure.strengthtraining.traditional")
                }
                .tag(3)

            SettingsView()
                .tabItem {
                    Label(L.settings, systemImage: "gearshape.fill")
                }
                .tag(4)
        }
        .tint(.orange)
    }
}
