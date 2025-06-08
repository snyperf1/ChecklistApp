import SwiftUI

struct TaskRow: View {
    @EnvironmentObject var store: TaskStore
    let task: Task

    var body: some View {
        HStack {
            Button(action: { store.toggle(task) }) {
                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isDone ? .green : .gray)
            }
            .buttonStyle(PlainButtonStyle())

            Text(task.text)
                .strikethrough(task.isDone)
                .foregroundColor(task.isDone ? .secondary : .primary)

            Spacer()

            Button(action: { store.delete(task) }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding(.vertical, 4)
    }
}
