//
//  StationController.swift
//  KMPK
//
//  Created by Karol Bukowski on 03.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

protocol StationBoardData {
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

fileprivate struct ResultData: StationBoardData {
    var line: String
    var direction: String
    var lastStop: String
    var estimatedMinutes: Int
    var scheduledDepartureTime: String
    var routeStared: Bool
    var poorGPS: Bool
    var disabledFacilities: Bool
    var airConditioning: Bool
    
    static let empty = ResultData(line: "",
                                          direction: "",
                                          lastStop: "",
                                          estimatedMinutes: 0,
                                          scheduledDepartureTime: "",
                                          routeStared: false,
                                          poorGPS: false,
                                          disabledFacilities: false,
                                          airConditioning: false)
}

protocol OldStationControllerDelegate: class {
    func oldStationController(_ controller: OldStationController, station: [StationBoardData])
}

class OldStationController {
    weak var delegate: OldStationControllerDelegate?
    
    func show(id: String) {
        let query = TStationBoardQuery(id: id)

        Session.shared.api.execute(query, successJSON: { [weak self] (results) in
            let station = self?.parseShow(result: results)

            DispatchQueue.main.async {
                self?.delegate?.oldStationController(self!, station: station!)
            }
        }) { (error) in
            APILog.debug(error)
        }
        
    }
    
    private func parseShow(result: TStationBoardQuery.Result) -> [ResultData] {
        guard let station = result.first?.value else {
            return []
        }
        
        var output = [ResultData]()
        
        for board in station.board {
            var data = ResultData.empty
            
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
