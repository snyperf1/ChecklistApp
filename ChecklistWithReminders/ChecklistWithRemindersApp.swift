import SwiftUI

@main
struct ChecklistWithRemindersApp: App {
    @StateObject private var store = TaskStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .onAppear {
                    NotificationManager.requestPermission()
                    NotificationManager.scheduleReminders()
                }
        }
    }
}
