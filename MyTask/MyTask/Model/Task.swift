import Foundation

struct Task {
    let id: UUID
    var name: String
    var description: String
    var isCompleted: Bool
    var finishDate: Date
    
    static func createEmptyTasks() -> Task {
        return Task(id: UUID(), name: "", description: "", isCompleted: false, finishDate: Date())
    }
}
