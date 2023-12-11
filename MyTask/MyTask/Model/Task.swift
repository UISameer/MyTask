import Foundation

struct Task {
    let id: Int
    var name: String
    var description: String
    var isCompleted: Bool
    var finishDate: Date
    
    static func createMockTasks() -> [Task] {
        return[
            Task(id: 1, name: "Buy Groceries from super market", description: "Grocery task", isCompleted: false, finishDate: Date()),
            Task(id: 2, name: "Pay rent online", description: "Rent payment and ask receipt to the owner", isCompleted: false, finishDate: Date()),
            Task(id: 3, name: "Recharge mobile iwth 666 plan", description: "Recharge", isCompleted: true, finishDate: Date()),
            
        ]
    }
}
