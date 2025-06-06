// TaskStore.swift

import Foundation
import Combine

final class TaskStore: ObservableObject {
    // Default tasks (modify as you like)
    private let defaultMorningTasks = [
        Task(text: "Wake up", section: .morning),
        Task(text: "Pray & read Scripture", section: .morning),
        Task(text: "Brush teeth & wash face", section: .morning),
        Task(text: "Have breakfast", section: .morning),
        Task(text: "Plan assignments/priorities", section: .morning)
    ]

    private let defaultNightTasks = [
        Task(text: "Review the day & thank God", section: .night),
        Task(text: "Brush teeth & wash face", section: .night),
        Task(text: "Prep assignment tasks for tomorrow", section: .night),
        Task(text: "Read before bed", section: .night),
        Task(text: "Sleep on time", section: .night)
    ]

    @Published var morningTasks: [Task] = []
    @Published var nightTasks: [Task] = []

    private var currentDateKey: String {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: today)
    }

    private let storageKey = "DailyChecklist_Tasks"

    init() {
        loadTasksForToday()
    }

    // MARK: - Loading & Saving

    private func loadTasksForToday() {
        let defaults = UserDefaults.standard

        if let savedData = defaults.data(forKey: storageKey),
           let wrapper = try? JSONDecoder().decode(TaskWrapper.self, from: savedData),
           wrapper.dateKey == currentDateKey {
            self.morningTasks = wrapper.morning
            self.nightTasks = wrapper.night
        } else {
            self.morningTasks = defaultMorningTasks
            self.nightTasks = defaultNightTasks
            saveTasks()
        }
    }

    private func saveTasks() {
        let wrapper = TaskWrapper(dateKey: currentDateKey,
                                  morning: morningTasks,
                                  night: nightTasks)
        if let encoded = try? JSONEncoder().encode(wrapper) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }

    // MARK: - Public API

    func toggleDone(_ task: Task) {
        switch task.section {
        case .morning:
            if let index = morningTasks.firstIndex(where: { $0.id == task.id }) {
                morningTasks[index].isDone.toggle()
            }
        case .night:
            if let index = nightTasks.firstIndex(where: { $0.id == task.id }) {
                nightTasks[index].isDone.toggle()
            }
        }
        saveTasks()
    }

    func addTask(text: String, to section: TaskSection) {
        let newTask = Task(text: text, section: section)
        switch section {
        case .morning:
            morningTasks.append(newTask)
        case .night:
            nightTasks.append(newTask)
        }
        saveTasks()
    }

    func deleteTask(_ task: Task) {
        switch task.section {
        case .morning:
            morningTasks.removeAll { $0.id == task.id }
        case .night:
            nightTasks.removeAll { $0.id == task.id }
        }
        saveTasks()
    }
}

private struct TaskWrapper: Codable {
    let dateKey: String
    let morning: [Task]
    let night: [Task]
}
