//
//  StationController.swift
//  KMPK
//
//  Created by Karol Bukowski on 20.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation
import CoreData

class StationController {
    private let database: DatabaseAccess
    
    init(database: DatabaseAccess) {
        self.database = database
    }
    
    func search(name: String) -> [StationData] {
        let query = name.components(separatedBy: CharacterSet.alphanumerics.inverted)
        
        let subpredicates = query.map{ NSPredicate(format: "(name BEGINSWITH[c] %@) OR (name MATCHES[c] %@)", $0, String(format: ".*[^\\w]%@.*", $0)) }
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: subpredicates)

        
        return search(predicate: predicate)
    }
    
    func search(id: String) -> [StationData] {
        let query = id.components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
        
        let predicate = NSPredicate(format: "id BEGINSWITH %@", query)
        
        return search(predicate: predicate)
    }
    
    func get(id: String) -> [StationData] {
        let predicate = NSPredicate(format: "id = %@", id)
        
        return search(predicate: predicate)
    }
}

// MARK:- Helpers
extension StationController {
    private func search(predicate: NSPredicate) -> [StationData] {
        let context = self.database.readContext
        
        let sort = NSSortDescriptor(key: "name", ascending: true)
        
        let request = NSFetchRequest<CoreStation>(entityName: String(describing: CoreStation.self))
        request.predicate = predicate
        request.sortDescriptors = [sort]
        request.fetchLimit = 50
        
        do {
            let result = try context.fetch(request)
            return result.map{ StationData(core: $0) }
        } catch {
            return []
        }
        
    }
}
