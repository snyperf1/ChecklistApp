# Mobile Checklist App with Reminders

This directory contains Swift source files for a basic checklist iOS app built with SwiftUI.
The app supports daily reminders via local notifications and automatically adapts to different screen sizes.

## Building

1. Open **Xcode** and create a new **App** project using the SwiftUI template.
2. Delete the default `ContentView.swift` and `YourAppNameApp.swift` files.
3. Copy the Swift files from `ChecklistWithReminders` into your project.
4. Ensure all files are added to the app target.
5. Run on an iPhone simulator or device. The checklist interface will display with sections for "Morning" and "Evening" tasks, progress bars and notification reminders.

Notifications fire at 8 AM and 8 PM by default. You can customise the schedule in `NotificationManager.swift`.
