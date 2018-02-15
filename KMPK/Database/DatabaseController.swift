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
    var persistentContainer: NSPersistentContainer!
    
    public init() {
        let bundleIdentifier = "kb.KMPK"
        
        guard let bundle = Bundle(identifier: bundleIdentifier) else {
            fatalError("Missing bundle with id = \(bundleIdentifier)")
        }
        
        guard let url = bundle.url(forResource: "Database", withExtension: "momd") else {
            fatalError("Missing Database.momd")
        }
        
        guard let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Database.momd cannot be opened")
        }
        
        self.persistentContainer = NSPersistentContainer(name: "Database", managedObjectModel: model)
        
        self.persistentContainer.loadPersistentStores { ( _ , error) in
            if let error = error {
                fatalError("Failed to load store: \(error)")
            }
        }
    }
}

// MARK:- Database
extension DatabaseController: DatabaseAccess {    
    var viewContext: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
}
