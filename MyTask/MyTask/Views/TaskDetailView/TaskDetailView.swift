import SwiftUI

struct TaskDetailView: View {
    
    @ObservedObject var taskViewModel: TaskViewModel
    @Binding var showTaskDetailView: Bool
    @Binding var selectedTask: Task
    @Binding var refreshTaskList: Bool
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Task Detail")) {
                    TextField("Task name", text: $selectedTask.name)
                    TextEditor(text: $selectedTask.description)
                    Toggle("Mark Complete", isOn: $selectedTask.isCompleted)
                }
                
                Section(header: Text("Task Date/Time")) {
                    DatePicker("Task Date", selection: $selectedTask.finishDate)
                }
                
                Section {
                    Button {
                        if(taskViewModel.deleteTask(task: selectedTask)) {
                            showTaskDetailView.toggle()
                            refreshTaskList.toggle()
                        }
                    } label: {
                        Text("Delete")
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                
            }.navigationTitle("Task Detail")
                .toolbar{
                    ToolbarItem(placement: .topBarLeading) {
                        Button{
                            showTaskDetailView = false
                        } label: {
                            Text("Cancel")
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button{
                            if(taskViewModel.updateTask(task: selectedTask)) {
                                showTaskDetailView.toggle()
                                refreshTaskList.toggle()
                            }
                        } label: {
                            Text("Update")
                        }
                    }
                }
        }
    }
}

#Preview {
    TaskDetailView(taskViewModel: TaskViewModel(), showTaskDetailView: .constant(false), selectedTask: .constant(Task.createMockTasks().first!),
                   refreshTaskList: .constant(false)
    )
}
