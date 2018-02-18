//
//  DatabaseAccess.swift
//  KMPK
//
//  Created by Karol Bukowski on 13.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation
import CoreData

protocol DatabaseAccess {
    var readContext: NSManagedObjectContext { get }
    
    func getWorkContext(_ closure: @escaping (_ context: NSManagedObjectContext) -> Void, complition: ((_ success: Bool) -> Void)?)
}
