import Foundation
import UserNotifications

struct NotificationManager {
    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    static func scheduleDailyReminders() {
        let morningTime = DateComponents(hour: 8, minute: 0)
        scheduleReminder(at: morningTime, title: "Morning Checklist Reminder", identifier: "morning_reminder")

        let nightTime = DateComponents(hour: 21, minute: 0)
        scheduleReminder(at: nightTime, title: "Night Checklist Reminder", identifier: "night_reminder")
    }

    private static func scheduleReminder(at time: DateComponents, title: String, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
