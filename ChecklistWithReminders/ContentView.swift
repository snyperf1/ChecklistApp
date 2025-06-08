import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: TaskStore
    @State private var newMorning = ""
    @State private var newEvening = ""

    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .full
        return df
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    section(title: "Morning", tasks: store.morningTasks, binding: $newMorning, sectionType: .morning)
                    section(title: "Evening", tasks: store.eveningTasks, binding: $newEvening, sectionType: .evening)
                }
                .padding()
            }
            .navigationTitle("Daily Checklist")
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(dateFormatter.string(from: Date()))
                .font(.headline)
                .foregroundColor(.secondary)
            ProgressView(value: store.overallProgress)
                .accentColor(.blue)
        }
    }

    private func section(title: String, tasks: [Task], binding: Binding<String>, sectionType: TaskSection) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.title2)
                    .bold()
                Spacer()
                ProgressView(value: sectionType == .morning ? store.morningProgress : store.eveningProgress)
            }
            .padding(.bottom, 4)

            ForEach(tasks) { task in
                TaskRow(task: task)
                    .environmentObject(store)
            }

            HStack {
                TextField("Add task", text: binding)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 44)
                Button("Add") {
                    addTask(text: binding.wrappedValue, section: sectionType)
                    binding.wrappedValue = ""
                }
            }
        }
    }

    private func addTask(text: String, section: TaskSection) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        store.add(trimmed, section: section)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(TaskStore())
    }
}
