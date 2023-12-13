import CoreData

final class PersistenceController {
    static let shared = PersistenceController()

    private let container: NSPersistentContainer
    var viewContext: NSManagedObjectContext
    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MyTask")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        viewContext = container.viewContext
    }
}
