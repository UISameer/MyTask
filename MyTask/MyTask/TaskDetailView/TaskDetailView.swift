import SwiftUI

struct TaskDetailView: View {
    
    @ObservedObject var taskViewModel: TaskViewModel
    @Binding var showATaskDetailView: Bool
    @Binding var selectedTask: Task
    
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
                            showATaskDetailView = false
                        } label: {
                            Text("Cancel")
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button{
                            print("Updated")
                        } label: {
                            Text("Update")
                        }
                    }
                }
        }
    }
}

#Preview {
    TaskDetailView(taskViewModel: TaskViewModel(), showATaskDetailView: .constant(false), selectedTask: .constant(Task.createMockTasks().first!))
}
