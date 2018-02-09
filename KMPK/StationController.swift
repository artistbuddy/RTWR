//
//  StationController.swift
//  KMPK
//
//  Created by Karol Bukowski on 03.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

protocol StationSearchResults {
    var line: String { get }
    var direction: String { get }
    var lastStop: String { get }
    var estimatedMinutes: Int { get }
    var scheduledDepartureTime: String { get }
    var routeStared: Bool { get }
    var poorGPS: Bool { get }
    var disabledFacilities: Bool { get }
    var airConditioning: Bool { get }
    
}

struct StationResultData: StationSearchResults {
    var line: String
    var direction: String
    var lastStop: String
    var estimatedMinutes: Int
    var scheduledDepartureTime: String
    var routeStared: Bool
    var poorGPS: Bool
    var disabledFacilities: Bool
    var airConditioning: Bool
    
    static let empty = StationResultData(line: "",
                                          direction: "",
                                          lastStop: "",
                                          estimatedMinutes: 0,
                                          scheduledDepartureTime: "",
                                          routeStared: false,
                                          poorGPS: false,
                                          disabledFacilities: false,
                                          airConditioning: false)
}

protocol StationControllerDelegate: class {
    func stationController(_ controller: StationController, station: [StationSearchResults])
}

class StationController {
    weak var delegate: StationControllerDelegate?
    
    func show(id: String) {
        let query = StationBoardQuery(id: id)
        
        Session.api.execute(query, success: { [weak self] (results) in            
            let station = self?.parseShow(result: results)
            
            DispatchQueue.main.async {
                self?.delegate?.stationController(self!, station: station!)
            }
        }) { (error) in
            APILog.debug(error)
        }
        
    }
    
    private func parseShow(result: StationBoardQuery.Result) -> [StationResultData] {
        guard let station = result.first?.value else {
            return []
        }
        
        var output = [StationResultData]()
        
        for board in station.board {
            var data = StationResultData.empty
            
            data.line = board.line
            data.direction = board.direction
            data.lastStop = board.currentStop.name
            data.estimatedMinutes = board.minuteCount
            data.routeStared = !(board.routeBegin)
            data.scheduledDepartureTime = board.scheduledDepartureTime
            data.poorGPS = (board.lag > 10000) ? true : false
            data.airConditioning = board.ac
            //data.disabledFacilities implement!
            
            output.append(data)
        }
        
        return output
    }
}
