import SwiftUI

struct HomeView: View {
    
    @StateObject var taskViewModel: TaskViewModel = TaskViewModelFactory.createTaskViewModel()
    @State private var showAddTaskView: Bool = false
    @State private var showTaskDetailView: Bool = false
    @State private var selectedTask: Task = Task.createEmptyTasks()
    @State private var showErrorAlert: Bool = false
    @State var defaultPickerSelectedItem: String = "Active"
    
    var body: some View {
        
        NavigationStack {
            
            PickerComponent(defaultPickerSelectedItem: $defaultPickerSelectedItem)
                .onChange(of: defaultPickerSelectedItem) {
                    taskViewModel.getTasks(isCompleted: defaultPickerSelectedItem == "Active")
                }
            
            List(taskViewModel.tasks, id: \.id) { task in
                VStack(alignment: .leading) {
                    Text(task.name).font(.title3)
                    HStack {
                        Text(task.description).font(.subheadline).lineLimit(2)
                        Spacer()
                        Text(task.finishDate.toString()).font(.caption2)
                            .fontWeight(.semibold)
                    }
                }.onTapGesture {
                    selectedTask = task
                    showTaskDetailView.toggle()
                }
            }.onAppear {
                taskViewModel.getTasks(isCompleted: true)
            }.onDisappear(perform: {
                taskViewModel.cancelSubscription()
            })
            .alert("Task Error", isPresented: $taskViewModel.showError, actions: {
                Button(action: {}) {
                    Text("Ok")
                }
            }, message:{
                Text(taskViewModel.errorMessage)
            })
            .listStyle(.plain)
            .navigationTitle("Home")
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddTaskView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }.sheet(isPresented: $showAddTaskView) {
                AddTaskView(taskViewModel: taskViewModel, showAddTaskView: $showAddTaskView)
            }
            .sheet(isPresented: $showTaskDetailView) {
                TaskDetailView(taskViewModel: taskViewModel, showTaskDetailView: $showTaskDetailView, selectedTask: $selectedTask)
            }
        }
    }
}

#Preview {
    HomeView()
}
