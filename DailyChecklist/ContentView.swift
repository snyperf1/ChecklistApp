// ContentView.swift

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: TaskStore

    @State private var newMorningTask = ""
    @State private var newNightTask = ""

    private let headerDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .full
        return df
    }()

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 4) {
                Text("📝 Daily Checklist")
                    .font(.largeTitle).bold()
                Text(headerDateFormatter.string(from: Date()))
                    .font(.subheadline).foregroundColor(.secondary)
                Text("\"Commit your work to the Lord, and your plans will be established.\" – Proverbs 16:3")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.top, 2)
                ProgressView(value: store.overallProgress)
                    .accentColor(.green)
                    .padding(.top, 4)
            }
            .padding(.bottom, 12)

            Divider()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Section(header: Text("☀️ Morning")
                                .font(.title2).bold()
                                .padding(.bottom, 4)
                    ) {
                        ProgressView(value: store.morningProgress)
                            .accentColor(.blue)
                        VStack(spacing: 8) {
                            ForEach(store.morningTasks) { task in
                                TaskRow(task: task)
                                    .environmentObject(store)
                            }
                            HStack {
                                TextField("Add a morning task…", text: $newMorningTask, onCommit: {
                                    addMorningTask()
                                })
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(height: 44)

                                Button(action: {
                                    addMorningTask()
                                }) {
                                    Text("Add")
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.blue.opacity(0.8))
                                        .foregroundColor(.white)
                                        .cornerRadius(6)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }

                    Section(header: Text("🌙 Night")
                                .font(.title2).bold()
                                .padding(.bottom, 4)
                    ) {
                        ProgressView(value: store.nightProgress)
                            .accentColor(.purple)
                        VStack(spacing: 8) {
                            ForEach(store.nightTasks) { task in
                                TaskRow(task: task)
                                    .environmentObject(store)
                            }
                            HStack {
                                TextField("Add a night task…", text: $newNightTask, onCommit: {
                                    addNightTask()
                                })
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(height: 44)

                                Button(action: {
                                    addNightTask()
                                }) {
                                    Text("Add")
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.blue.opacity(0.8))
                                        .foregroundColor(.white)
                                        .cornerRadius(6)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }

            Spacer()

            HStack {
                Spacer()
                Text("Daily Checklist • v1.1")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding(.top, 12)
        }
        .padding()
        .frame(minWidth: 450, minHeight: 600)
    }

    private func addMorningTask() {
        let text = newMorningTask.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        store.addTask(text: text, to: .morning)
        newMorningTask = ""
    }

    private func addNightTask() {
        let text = newNightTask.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        store.addTask(text: text, to: .night)
        newNightTask = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(TaskStore())
    }
}
