import SwiftUI

struct AddTaskView: View {
    
    @ObservedObject var taskViewModel: TaskViewModel
    @State private var taskToAdd: Task = Task(id: 0, name: "", description: "", isCompleted: false, finishDate: Date())
    @Binding var showAddTaskView: Bool
    @Binding var refreshTaskList: Bool
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Task Detail")) {
                    TextField("Task name", text: $taskToAdd.name)
                    TextEditor(text: $taskToAdd.description)
                }
                
                Section(header: Text("Task Date/Time")) {
                    DatePicker("Task Date", selection: $taskToAdd.finishDate)
                }
            }.navigationTitle("Add Task")
                .toolbar{
                    ToolbarItem(placement: .topBarLeading) {
                        Button{
                            showAddTaskView = false
                        } label: {
                            Text("Cancel")
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button{
                            if(taskViewModel.addTask(task: taskToAdd)) {
                                showAddTaskView.toggle()
                                refreshTaskList.toggle()
                            }
                        } label: {
                            Text("Add")
                        }
                    }
                }
        }
    }
}

#Preview {
    AddTaskView(taskViewModel: TaskViewModel(), showAddTaskView: .constant(false), refreshTaskList: .constant(false))
}
