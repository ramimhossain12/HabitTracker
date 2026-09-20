
import SwiftUI
import SwiftData

@main
struct HabitTrackerApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Habit.self)
    }
}
