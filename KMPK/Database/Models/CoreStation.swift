//
//  CoreStation+CoreDataProperties.swift
//  KMPK
//
//  Created by Karol Bukowski on 18.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CoreStation)
public class CoreStation: NSManagedObject {
    
}

extension CoreStation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreStation> {
        return NSFetchRequest<CoreStation>(entityName: "CoreStation")
    }

    @NSManaged public var id: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String
    @NSManaged public var type: Int16
    @NSManaged public var routes: Set<CoreStationRoute>

}

// MARK: Generated accessors for routes
extension CoreStation {

    @objc(addRoutesObject:)
    @NSManaged public func addToRoutes(_ value: CoreStationRoute)

    @objc(removeRoutesObject:)
    @NSManaged public func removeFromRoutes(_ value: CoreStationRoute)

    @objc(addRoutes:)
    @NSManaged public func addToRoutes(_ values: Set<CoreStationRoute>)

    @objc(removeRoutes:)
    @NSManaged public func removeFromRoutes(_ values: Set<CoreStationRoute>)

}
