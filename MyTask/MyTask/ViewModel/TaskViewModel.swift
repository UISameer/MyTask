import Foundation

final class TaskViewModel: ObservableObject {
    
    private let taskRepository: TaskRepository
    @Published var tasks: [Task] = []
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }
    
    func getTasks(isCompleted: Bool) {
        let result = self.taskRepository.get(isCompleted: !isCompleted)
        switch result {
            case .success(let fetchedTask):
                self.errorMessage = ""
                self.tasks = fetchedTask
            case .failure(let failure):
                self.processOperationError(failure)
        }
    }
    
    func addTask(task: Task) -> Bool {
        let result = taskRepository.add(task: task)
        return processOperationResult(operationResult: result)
    }
    
    func updateTask(task: Task) -> Bool {
        let result = taskRepository.update(task: task)
        return processOperationResult(operationResult: result)
    }
    
    func deleteTask(task: Task) -> Bool {
        let result = taskRepository.delete(task: task)
        return processOperationResult(operationResult: result)
    }
    
    private func processOperationResult(operationResult: Result<Bool, TaskRepositoryError>) -> Bool {
        switch operationResult {
            case .success(let success):
                self.errorMessage = ""
                return success
            case .failure(let failure):
                self.processOperationError(failure)
                return false
        }
    }
    
    private func processOperationError(_ error: TaskRepositoryError) {
        switch error {
            case .operationFailure(let errorMessage):
                self.showError = true
                self.errorMessage = errorMessage
        }
    }
}
