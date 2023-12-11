import Foundation

struct Task {
    let id: Int
    var name: String
    var description: String
    var isActive: Bool
    var finishDate: Date
    
    static func createMockTasks() -> [Task] {
        return[
            Task(id: 1, name: "Buy Groceries from super market", description: "Grocery task", isActive: true, finishDate: Date()),
            Task(id: 2, name: "Pay rent online", description: "Rent payment and ask receipt to the owner", isActive: true, finishDate: Date()),
            Task(id: 3, name: "Recharge mobile iwth 666 plan", description: "Recharge", isActive: false, finishDate: Date()),
            
        ]
    }
}
