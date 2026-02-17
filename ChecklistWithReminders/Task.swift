import Foundation

enum TaskSection: String, Codable {
    case morning
    case evening
}

struct Task: Identifiable, Codable {
    var id: UUID = .init()
    var text: String
    var isDone: Bool = false
    var section: TaskSection
}
