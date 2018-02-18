//
//  CoreStationRoute+CoreDataProperties.swift
//  KMPK
//
//  Created by Karol Bukowski on 18.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CoreStationRoute)
public class CoreStationRoute: NSManagedObject {
    
}

extension CoreStationRoute {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreStationRoute> {
        return NSFetchRequest<CoreStationRoute>(entityName: "CoreStationRoute")
    }

    @NSManaged public var direction: String
    @NSManaged public var line: String

}
