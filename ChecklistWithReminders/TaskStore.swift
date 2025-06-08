import Foundation
import Combine

final class TaskStore: ObservableObject {
    @Published var morningTasks: [Task] = []
    @Published var eveningTasks: [Task] = []

    private let defaultsKey = "MobileChecklistTasks"
    private var dateKey: String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: Date())
    }

    init() {
        load()
    }

    var morningProgress: Double {
        guard !morningTasks.isEmpty else { return 0 }
        return Double(morningTasks.filter { $0.isDone }.count) / Double(morningTasks.count)
    }

    var eveningProgress: Double {
        guard !eveningTasks.isEmpty else { return 0 }
        return Double(eveningTasks.filter { $0.isDone }.count) / Double(eveningTasks.count)
    }

    var overallProgress: Double {
        let total = morningTasks.count + eveningTasks.count
        guard total > 0 else { return 0 }
        let done = morningTasks.filter { $0.isDone }.count + eveningTasks.filter { $0.isDone }.count
        return Double(done) / Double(total)
    }

    func toggle(_ task: Task) {
        switch task.section {
        case .morning:
            if let index = morningTasks.firstIndex(where: { $0.id == task.id }) {
                morningTasks[index].isDone.toggle()
            }
        case .evening:
            if let index = eveningTasks.firstIndex(where: { $0.id == task.id }) {
                eveningTasks[index].isDone.toggle()
            }
        }
        save()
    }

    func add(_ text: String, section: TaskSection) {
        let new = Task(text: text, section: section)
        switch section {
        case .morning: morningTasks.append(new)
        case .evening: eveningTasks.append(new)
        }
        save()
    }

    func delete(_ task: Task) {
        switch task.section {
        case .morning: morningTasks.removeAll { $0.id == task.id }
        case .evening: eveningTasks.removeAll { $0.id == task.id }
        }
        save()
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: defaultsKey),
              let wrapper = try? JSONDecoder().decode(TaskWrapper.self, from: data),
              wrapper.date == dateKey else {
            morningTasks = [
                Task(text: "Wake up", section: .morning),
                Task(text: "Pray or meditate", section: .morning),
                Task(text: "Plan your day", section: .morning)
            ]
            eveningTasks = [
                Task(text: "Review the day", section: .evening),
                Task(text: "Prepare for tomorrow", section: .evening),
                Task(text: "Go to bed on time", section: .evening)
            ]
            save()
            return
        }
        morningTasks = wrapper.morning
        eveningTasks = wrapper.evening
    }

    private func save() {
        let wrapper = TaskWrapper(date: dateKey, morning: morningTasks, evening: eveningTasks)
        if let data = try? JSONEncoder().encode(wrapper) {
            UserDefaults.standard.set(data, forKey: defaultsKey)
        }
    }
}

private struct TaskWrapper: Codable {
    let date: String
    let morning: [Task]
    let evening: [Task]
}
