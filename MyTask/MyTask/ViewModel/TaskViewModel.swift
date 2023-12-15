import Foundation
import Combine

final class TaskViewModel: ObservableObject {
    
    private let taskRepository: TaskRepository
    @Published var tasks: [Task] = []
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    private var cancellable = Set<AnyCancellable>()
    private var _isCompleted = false
    var shouldDismiss = PassthroughSubject<Bool, Never>()
    
    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }
    
    deinit {
        cancelSubscription()
    }
    
    func cancelSubscription() {
        cancellable.forEach{ $0.cancel() }
    }
    
    func getTasks(isCompleted: Bool) {
        _isCompleted = isCompleted
        self.taskRepository.get(isCompleted: !isCompleted)
            .sink { result in
                switch result {
                    case .success(let fetchedTask):
                        self.errorMessage = ""
                        self.tasks = fetchedTask
                    case .failure(let failure):
                        self.processOperationError(failure)
                }
            }.store(in: &cancellable)
    }
    
    func addTask(task: Task) {
        taskRepository.add(task: task)
            .sink { [weak self] result in
                self?.processOperationResult(operationResult: result)
            }.store(in: &cancellable)
    }
    
    func updateTask(task: Task) {
        taskRepository.update(task: task)
            .sink { [weak self] result in
                self?.processOperationResult(operationResult: result)
            }.store(in: &cancellable)
    }
    
    func deleteTask(task: Task) {
        taskRepository.delete(task: task)
            .sink { [weak self] result in
                self?.processOperationResult(operationResult: result)
            }.store(in: &cancellable)
    }
    
    private func processOperationResult(operationResult: Result<Bool, TaskRepositoryError>) {
        switch operationResult {
            case .success(_):
                self.errorMessage = ""
                self.getTasks(isCompleted: _isCompleted)
                shouldDismiss.send(true)
            case .failure(let failure):
                self.processOperationError(failure)
        }
    }
    
    private func processOperationError(_ error: TaskRepositoryError) {
        switch error {
            case .operationFailure(let errorMessage):
                self.showError = true
                self.errorMessage = errorMessage
                shouldDismiss.send(false)
        }
    }
}
