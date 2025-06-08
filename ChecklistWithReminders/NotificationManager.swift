import Foundation
import UserNotifications

struct NotificationManager {
    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    static func scheduleReminders() {
        let morning = DateComponents(hour: 8, minute: 0)
        schedule(time: morning, title: "Morning Checklist Reminder", id: "morning_reminder")

        let evening = DateComponents(hour: 20, minute: 0)
        schedule(time: evening, title: "Evening Checklist Reminder", id: "evening_reminder")
    }

    private static func schedule(time: DateComponents, title: String, id: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.sound = .default
        let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
