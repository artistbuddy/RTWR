//
//  DatabaseController.swift
//  KMPK
//
//  Created by Karol Bukowski on 13.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation
import CoreData

class DatabaseController {
    private let container: NSPersistentContainer!
    private let queue : OperationQueue = {
        let queue = OperationQueue.init();
        queue.maxConcurrentOperationCount = 1;
        return queue;
    }()
    
    init() {
        let bundleIdentifier = "kb.KMPK"
        let name = "Database"
        
        guard let bundle = Bundle(identifier: bundleIdentifier) else {
            fatalError("Missing bundle with id = \(bundleIdentifier)")
        }
        
        guard let url = bundle.url(forResource: name, withExtension: "momd") else {
            fatalError("Missing Database.momd")
        }
        
        guard let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("\(name).momd cannot be opened")
        }
        
        self.container = NSPersistentContainer(name: name, managedObjectModel: model)
        self.container.viewContext.automaticallyMergesChangesFromParent = true
        
        self.container.loadPersistentStores { ( _ , error) in
            if let error = error {
                fatalError("Failed to load store: \(error)")
            }
        }
    }

}

// MARK:- DatabaseAccess
extension DatabaseController: DatabaseAccess {
    func getWorkContext(_ closure: @escaping (_ context: NSManagedObjectContext) -> Void, complition: ((_ success: Bool) -> Void)?) {
        self.queue.addOperation {
            let context = self.container.newBackgroundContext();
            context.performAndWait {
                closure(context)
                do {
                    try context.save()
                    complition?(true)
                } catch let error {
                    APILog.debug("DatabaseController save error: \(error)")
                    complition?(false)
                }
            }
        }
    }
    
    var readContext: NSManagedObjectContext {
        return self.container.viewContext
    }
}
