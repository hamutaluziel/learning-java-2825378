import SwiftUI
import SwiftData

@main
struct FitnessTrackerApp: App {
    @StateObject private var healthKit = HealthKitService.shared
    @StateObject private var settings = AppSettings.shared

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([FoodEntry.self, CalisthenicsLog.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(healthKit)
                .environmentObject(settings)
                .modelContainer(sharedModelContainer)
                .environment(\.layoutDirection, .rightToLeft)
        }
    }
}
