//
//  StationController.swift
//  KMPK
//
//  Created by Karol Bukowski on 20.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation
import CoreData

fileprivate struct ResultData: StationData {
    let id: String
    let name: String
    let type: StationType
    let coordinates: Coordinates
    let routes: [StationRoute]
    
    init(core: CoreStation) {
        self.id = core.id
        self.name = core.name
        self.type = StationType(int16: core.type)!
        self.coordinates = Coordinates(lat: core.latitude, long: core.longitude)
        self.routes = Array(core.routes.map{ RouteData(core: $0) })
    }
}

fileprivate struct RouteData: StationRoute {
    let line: String
    let direction: String
    
    init(core: CoreStationRoute) {
        self.line = core.line
        self.direction = core.direction
    }
}

class StationController {
    private let database: DatabaseAccess
    
    init(database: DatabaseAccess) {
        self.database = database
    }
    
    func search(name: String) -> [StationData] {
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", name)
        
        return search(predicate: predicate)
    }
    
    func search(id: String) -> [StationData] {
        let predicate = NSPredicate(format: "id BEGINSWITH %@", id)
        
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
        
        let request = NSFetchRequest<CoreStation>(entityName: String(describing: CoreStation.self))
        request.predicate = predicate
        request.fetchLimit = 50
        
        do {
            let result = try context.fetch(request)
            return result.map{ ResultData(core: $0) }
        } catch {
            return []
        }
        
    }
}
