import SwiftUI

struct TaskDetailView: View {
    
    @ObservedObject var taskViewModel: TaskViewModel
    @Binding var showTaskDetailView: Bool
    @Binding var selectedTask: Task
    @State private var showDeleteAlert: Bool = false
    
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
                        showDeleteAlert.toggle()
                    } label: {
                        Text("Delete")
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }.alert("Delete Task?", isPresented: $showDeleteAlert) {
                        Button {
                            showTaskDetailView.toggle()
                        } label: {
                            Text("No")
                        }
                        
                        Button(role: .destructive) {
                            taskViewModel.deleteTask(task: selectedTask)
                        } label: {
                            Text("Yes")
                        }
                    } message: {
                        Text("Would you like to delete the task \(selectedTask.name)?")
                    }
                }
            }
            .onDisappear(perform: {
                taskViewModel.cancelSubscription()
            }).onReceive(taskViewModel.shouldDismiss, perform: { shouldDismiss in
                if(shouldDismiss) {
                    showTaskDetailView.toggle()
                }
            })
            .navigationTitle("Task Detail")
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
                        taskViewModel.updateTask(task: selectedTask)
                    } label: {
                        Text("Update")
                    }.disabled(selectedTask.name.isEmpty)
                }
            }.alert("Task Error", isPresented: $taskViewModel.showError, actions: {
                Button(action: {}) {
                    Text("Ok")
                }
            }, message:{
                Text(taskViewModel.errorMessage)
            })
        }
    }
}

#Preview {
    TaskDetailView(taskViewModel: TaskViewModelFactory.createTaskViewModel(), showTaskDetailView: .constant(false), selectedTask: .constant(Task.createEmptyTasks())
    )
}
