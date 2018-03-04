//
//  UpdateController.swift
//  KMPK
//
//  Created by Karol Bukowski on 18.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation
import CoreData

protocol UpdateProtocol {
    func update()
    func updateNeeded() -> Bool
}

protocol UpdateControllerDelegate: class {
    func updateControllerDidFinish()
    func updateController(progress: Int)
}

class UpdateController: UpdateProtocol {
    // MARK:- Public properties
    weak var delegate: UpdateControllerDelegate?
    
    // MARK:- Private properties
    private static let updateKey = "updatedAt"
    private class var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        return formatter
    }
    
    private let api: APIProtocol
    private let database: DatabaseAccess
    
    // MARK:- Initialization
    init() {
        self.api = Session.shared.api
        self.database = Session.shared.database
    }
    
    // MARK:- Public methods
    func update() {
        
        let dataSource = StationDataSource(api: self.api, policy: DataSourcePolicyController.global.getPolicy(dataSource: StationDataSource.self))
        let importer = StationImporter(database: self.database, dataSource: dataSource)
        
        importer.importData { (error) in
            if error == nil {
                UserDefaults.standard.set(UpdateController.dateFormatter.string(from: Date()), forKey: UpdateController.updateKey)
            }
            
            self.delegate?.updateControllerDidFinish()
        }
        
    }
    
    func updateNeeded() -> Bool {
        if UserDefaults.standard.value(forKey: UpdateController.updateKey) == nil {
            return true
        }
        
        return false
    }
    
    
    // MARK:- Private methods
    private func daysSinceLastUpdate() -> Int {
        guard
            let date = UserDefaults.standard.value(forKey: UpdateController.updateKey) as? String,
            let lastUpdate = UpdateController.dateFormatter.date(from: date)
            else {
                return -1
        }
        
        guard let days = Calendar.current.dateComponents([.day], from: lastUpdate, to: Date()).day else {
            return 0
        }
        
        return days
    }
}