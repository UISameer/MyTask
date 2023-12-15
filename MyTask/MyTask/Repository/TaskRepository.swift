import Foundation
import CoreData.NSManagedObjectContext
import Combine

protocol TaskRepository {
    func get(isCompleted: Bool) -> AnyPublisher<Result<[Task], TaskRepositoryError>, Never>
    func update(task: Task) -> AnyPublisher<Result<Bool, TaskRepositoryError>, Never>
    func add(task: Task) -> AnyPublisher<Result<Bool, TaskRepositoryError>, Never>
    func delete(task: Task) ->AnyPublisher<Result<Bool, TaskRepositoryError>, Never>
}

final class TaskRepositoryImplementation: TaskRepository {
    
    private let managedObjectContext: NSManagedObjectContext = PersistenceController.shared.viewContext
    
    func get(isCompleted: Bool) -> AnyPublisher<Result<[Task], TaskRepositoryError>, Never> {
        let fetchRequest = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isCompleted == %@", NSNumber(value: isCompleted))
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            if(!result.isEmpty) {
                let clientContract = result.map({Task(id: $0.id!, name: $0.name ?? "",
                                                      description: $0.taskDescription ?? "",
                                                      isCompleted: $0.isCompleted,
                                                      finishDate: $0.finishDate ?? Date())})
                return Just(.success(clientContract)).eraseToAnyPublisher()
            }
            return Just(.success([])).eraseToAnyPublisher()
        } catch {
            print("Error \(error.localizedDescription)")
            return Just(.failure(.operationFailure(error.localizedDescription))).eraseToAnyPublisher()
        }
    }
    
    func update(task: Task) -> AnyPublisher<Result<Bool, TaskRepositoryError>, Never> {
        let fetchRequest = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        do {
            if let existingTask = try managedObjectContext.fetch(fetchRequest).first {
                existingTask.name = task.name
                existingTask.taskDescription = task.description
                existingTask.isCompleted = task.isCompleted
                existingTask.finishDate = task.finishDate
                
                try managedObjectContext.save()
                return Just(.success(true)).eraseToAnyPublisher()
            } else {
                print("No task found with the id \(task.id)")
                return Just(.failure(.operationFailure("No task found with the id \(task.id)"))).eraseToAnyPublisher()
            }
        } catch  {
            managedObjectContext.rollback()
            print("Error \(error.localizedDescription)")
            return Just(.failure(.operationFailure("error.localizedDescription"))).eraseToAnyPublisher()
        }
    }
    
    func add(task: Task) -> AnyPublisher<Result<Bool, TaskRepositoryError>, Never> {
        let taskEntity = TaskEntity(context: managedObjectContext)
        taskEntity.id = UUID()
        taskEntity.isCompleted = false
        taskEntity.name = task.name
        taskEntity.taskDescription = task.description
        taskEntity.finishDate = task.finishDate
        
        do {
            try managedObjectContext.save()
            return Just(.success(true)).eraseToAnyPublisher()
        } catch  {
            managedObjectContext.rollback()
            print(error.localizedDescription)
            return Just(.failure(.operationFailure(error.localizedDescription))).eraseToAnyPublisher()
        }
    }
    
    func delete(task: Task) -> AnyPublisher<Result<Bool, TaskRepositoryError>, Never> {
        let fetchRequest = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        
        do {
            if let existingTask = try managedObjectContext.fetch(fetchRequest).first {
                managedObjectContext.delete(existingTask)
                try managedObjectContext.save()
                return Just(.success(true)).eraseToAnyPublisher()
            } else {
                print("No task with id \(task.id)")
                return Just(.failure(.operationFailure("No task with id \(task.id)"))).eraseToAnyPublisher()
            }
        } catch  {
            managedObjectContext.rollback()
            print(error.localizedDescription)
            return Just(.failure(.operationFailure(error.localizedDescription))).eraseToAnyPublisher()
        }
    }
}
