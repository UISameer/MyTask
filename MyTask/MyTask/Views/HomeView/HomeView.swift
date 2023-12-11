import SwiftUI

struct HomeView: View {
    
    @ObservedObject var taskViewModel: TaskViewModel = TaskViewModel()
    @State private var pickerFilters: [String] = ["Active", "Closed"]
    @State private var defaultPickerSelectedItem: String = "Active"
    
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
                }
            }.onAppear {
                taskViewModel.getTasks(isActive: true)
            }.listStyle(.plain)
                .navigationTitle("Home")
        }
    }
}

#Preview {
    HomeView()
}
