//
//  StationImporter.swift
//  KMPK
//
//  Created by Karol Bukowski on 13.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation
import CoreData

enum DataSourceImporterError: LocalizedError {
    case databaseError
    case invalidData
    case apiError(reason: LocalizedError)
    
    var errorDescription: String? {
        switch self {
        case .databaseError: return "Database error"
        case .invalidData: return "Invalid data"
        case .apiError(let reason): return reason.errorDescription
        }
    }
    
    var failureReason: String? {
        switch self {
        case .databaseError: return "Some internal problem occured"
        case .invalidData: return "Data type unsupported"
        case .apiError(let reason): return reason.failureReason
        }
    }
}

protocol DataSourceImporter {
    typealias ComplitionBlock = (_ error: DataSourceImporterError?) -> Void
    func importData(complition: ComplitionBlock?)
}

class StationImporter: DataSourceImporter {
    private let database: DatabaseAccess
    private let dataSource: StationDataSource
    
    private var stations: [StationData]?
    
    init(database: DatabaseAccess, dataSource: StationDataSource) {
        self.database = database
        self.dataSource = dataSource
    }
    
    func importData(complition: ComplitionBlock?) {
        download{ (error) in
            if let error = error {
                complition?(error)
                return
            }

            self.database(completion: { (error) in
                if let error = error {
                    complition?(error)
                } else {
                    complition?(nil)
                }
            })
        }
    }
    
    private func download(completion: ComplitionBlock?) {
        self.dataSource.download(success: { [weak self] (data) in
            self?.stations = data
            completion?(nil)
        }) { (failure) in
            completion?(DataSourceImporterError.apiError(reason: failure))
        }
    }
    
    private func database(completion: ComplitionBlock?) {
        guard let data = self.stations else {
            //should fatalError(), if data is nil some logic is fucked up
            APILog.debug("StationImporter data is nil")
            completion?(DataSourceImporterError.invalidData)
            return
        }
        
        self.database.getWorkContext({ (context) in
    
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CoreStation.fetchRequest()
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(batchDeleteRequest)
            } catch {
                APILog.debug("StationImporter could't delete old content")
                completion?(DataSourceImporterError.databaseError)
                return
            }
            
            for item in data {
                
                let station = CoreStation(context: context)
                
                station.id = item.id
                station.name = item.name
                station.type = item.type.toInt16
                station.latitude = item.coordinates.latitude
                station.longitude = item.coordinates.longitute
                
                for item in item.routes {
                    let route = CoreStationRoute(context: context)
                    route.line = item.line
                    route.direction = item.direction
                    station.addToRoutes(route)
                }
                
            }
            
        }) { (success) in
            if success {
                completion?(nil)
            } else {
                completion?(DataSourceImporterError.databaseError)
            }
        }

    }
    
    
}
