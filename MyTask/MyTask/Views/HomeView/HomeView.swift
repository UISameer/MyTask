import SwiftUI

struct HomeView: View {
    
    @StateObject var taskViewModel: TaskViewModel = TaskViewModel()
    @State private var pickerFilters: [String] = ["Active", "Completed"]
    @State private var defaultPickerSelectedItem: String = "Active"
    @State private var showAddTaskView: Bool = false
    @State private var showTaskDetailView: Bool = false
    @State private var selectedTask: Task = Task(id: 0, name: "", description: "", isCompleted: false, finishDate: Date())
    @State private var refreshTaskList: Bool = false
    
    var body: some View {
        
        NavigationStack {
            
            Picker("Filter", selection: $defaultPickerSelectedItem) {
                ForEach(pickerFilters, id: \.self) {
                    Text($0)
                }
            }.pickerStyle(.segmented)
                .onChange(of: defaultPickerSelectedItem) { oldValue, newValue in
                    taskViewModel.getTasks(isActive: defaultPickerSelectedItem == "Active")
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
                taskViewModel.getTasks(isActive: true)
            }.onChange(of: refreshTaskList) { oldValue, newValue in
                taskViewModel.getTasks(isActive: defaultPickerSelectedItem == "Active")
            }
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
                AddTaskView(taskViewModel: taskViewModel, showAddTaskView: $showAddTaskView, refreshTaskList: $refreshTaskList)
            }
            .sheet(isPresented: $showTaskDetailView) {
                TaskDetailView(taskViewModel: taskViewModel, showTaskDetailView: $showTaskDetailView, selectedTask: $selectedTask, refreshTaskList: $refreshTaskList)
            }
        }
    }
}

#Preview {
    HomeView()
}
