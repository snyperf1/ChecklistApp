// DailyChecklistApp.swift

import SwiftUI

@main
struct DailyChecklistApp: App {
    @StateObject private var store = TaskStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
#if os(macOS)
        .windowStyle(HiddenTitleBarWindowStyle())
        .commands {
            CommandGroup(replacing: CommandGroupPlacement.newItem) { }
        }
#endif
    }
}
