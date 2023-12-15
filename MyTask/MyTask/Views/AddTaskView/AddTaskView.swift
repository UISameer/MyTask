import SwiftUI

struct AddTaskView: View {
    
    @ObservedObject var taskViewModel: TaskViewModel
    @State private var taskToAdd: Task = Task.createEmptyTasks()
    @Binding var showAddTaskView: Bool
    @State private var showCancelAlert: Bool = false
    
    var pickerDateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let currentDateComponent = calendar.dateComponents([.day, .month, .year, .hour, .minute], from: Date())
        let startDateComponent = DateComponents(year: currentDateComponent.year, month: currentDateComponent.month, day: currentDateComponent.day, hour: currentDateComponent.hour, minute: currentDateComponent.minute)
        let endDateComponent = DateComponents(year: 2024, month: 12, day: 31)
        return calendar.date(from: startDateComponent)! ... calendar.date(from: endDateComponent)!
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Task Detail")) {
                    TextField("Task name", text: $taskToAdd.name)
                    TextEditor(text: $taskToAdd.description)
                }
                
                Section(header: Text("Task Date/Time")) {
                    DatePicker("Task Date", selection: $taskToAdd.finishDate, in: pickerDateRange)
                }
            }.onReceive(taskViewModel.shouldDismiss, perform: { shouldDismiss in
                if(shouldDismiss) {
                    showAddTaskView.toggle()
                }
            })
            .navigationTitle("Add Task")
            .alert("Task Error", isPresented: $taskViewModel.showError, actions: {
                Button(action: {}) {
                    Text("Ok")
                }
            }, message:{
                Text(taskViewModel.errorMessage)
            })
            .onDisappear(perform: {
                taskViewModel.cancelSubscription()
            })
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Button{
                        if(!taskToAdd.name.isEmpty) {
                                // Show Alert
                            showCancelAlert.toggle()
                        } else {
                            showAddTaskView = false
                        }
                    } label: {
                        Text("Cancel")
                    }.alert("Save Task", isPresented: $showCancelAlert) {
                        Button {
                            showAddTaskView.toggle()
                        } label: {
                            Text("Cancel")
                        }
                        
                        Button {
                            addTask()
                        } label: {
                            Text("Save")
                        }
                    } message: {
                        Text("Would you like to save the task?")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        addTask()
                    } label: {
                        Text("Add")
                    }.disabled(taskToAdd.name.isEmpty)
                }
            }
        }
    }
    
    private func addTask() {
        taskViewModel.addTask(task: taskToAdd)
    }
}

#Preview {
    AddTaskView(taskViewModel: TaskViewModelFactory.createTaskViewModel(), showAddTaskView: .constant(false))
}
