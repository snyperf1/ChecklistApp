// Task.swift

import Foundation

enum TaskSection: String, Codable {
    case morning
    case night
}

struct Task: Identifiable, Codable {
    let id: UUID
    var text: String
    var isDone: Bool
    let section: TaskSection

    init(id: UUID = .init(),
         text: String,
         isDone: Bool = false,
         section: TaskSection)
    {
        self.id = id
        self.text = text
        self.isDone = isDone
        self.section = section
    }
}
