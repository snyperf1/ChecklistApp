// TaskRow.swift

import SwiftUI

struct TaskRow: View {
    @EnvironmentObject var store: TaskStore
    let task: Task

    var body: some View {
        HStack {
            Button(action: {
                store.toggleDone(task)
            }) {
                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isDone ? .green : .secondary)
                    .font(.title3)
            }
            .buttonStyle(PlainButtonStyle())

            Text(task.text)
                .strikethrough(task.isDone, color: .gray)
                .foregroundColor(task.isDone ? .gray : .primary)
                .font(.body)

            Spacer()

            Button(action: {
                store.deleteTask(task)
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding(.vertical, 4)
    }
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        let sample = Task(text: "Sample Task", isDone: false, section: .morning)
        TaskRow(task: sample)
            .environmentObject(TaskStore())
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
