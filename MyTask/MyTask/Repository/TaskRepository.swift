import Foundation
import CoreData.NSManagedObjectContext

protocol TaskRepository {
    func get(isCompleted: Bool) -> Result<[Task], TaskRepositoryError>
    func update(task: Task) -> Result<Bool, TaskRepositoryError>
    func add(task: Task) -> Result<Bool, TaskRepositoryError>
    func delete(task: Task) -> Result<Bool, TaskRepositoryError>
}

final class TaskRepositoryImplementation: TaskRepository {
    
    private let managedObjectContext: NSManagedObjectContext = PersistenceController.shared.viewContext
    
    func get(isCompleted: Bool) -> Result<[Task], TaskRepositoryError> {
        let fetchRequest = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isCompleted == %@", NSNumber(value: isCompleted))
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            if(!result.isEmpty) {
                return .success(result.map({Task(id: $0.id!, name: $0.name ?? "", description: $0.taskDescription ?? "", isCompleted: $0.isCompleted, finishDate: $0.finishDate ?? Date())}))
            }
            return .success([])
        } catch {
            print("Error \(error.localizedDescription)")
            return .failure(.operationFailure(error.localizedDescription))
        }
    }
    
    func update(task: Task) -> Result<Bool, TaskRepositoryError> {
        let fetchRequest = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        do {
            if let existingTask = try managedObjectContext.fetch(fetchRequest).first {
                existingTask.name = task.name
                existingTask.taskDescription = task.description
                existingTask.isCompleted = task.isCompleted
                existingTask.finishDate = task.finishDate
                
                try managedObjectContext.save()
                return .success(true)
            } else {
                print("No task found with the id \(task.id)")
                return .failure(.operationFailure("No task found with the id \(task.id)"))
            }
        } catch  {
            managedObjectContext.rollback()
            print("Error \(error.localizedDescription)")
            return .failure(.operationFailure("error.localizedDescription"))
        }
    }
    
    func add(task: Task) -> Result<Bool, TaskRepositoryError> {
        let taskEntity = TaskEntity(context: managedObjectContext)
        taskEntity.id = UUID()
        taskEntity.isCompleted = false
        taskEntity.name = task.name
        taskEntity.taskDescription = task.description
        taskEntity.finishDate = task.finishDate
        
        do {
            try managedObjectContext.save()
            return .success(true)
        } catch  {
            managedObjectContext.rollback()
            print(error.localizedDescription)
            return .failure(.operationFailure(error.localizedDescription))
        }
    }
    
    func delete(task: Task) -> Result<Bool, TaskRepositoryError> {
        let fetchRequest = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        
        do {
            if let existingTask = try managedObjectContext.fetch(fetchRequest).first {
                managedObjectContext.delete(existingTask)
                try managedObjectContext.save()
                return .success(true)
            } else {
                print("No task with id \(task.id)")
                return .failure(.operationFailure("No task with id \(task.id)"))
            }
        } catch  {
            managedObjectContext.rollback()
            print(error.localizedDescription)
            return .failure(.operationFailure(error.localizedDescription))
        }
    }
}
