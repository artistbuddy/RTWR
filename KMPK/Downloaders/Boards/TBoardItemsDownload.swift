//
//  TBoardItemsDownload.swift
//  KMPK
//
//  Created by Karol Bukowski on 10.03.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

class TBoardItemsDownload {
    // MARK:- Private properties
    private let api: APIProtocol
    private let stationID: String
    
    // MARK:- Initialization
    init(stationID: String, api: APIProtocol) {
        self.stationID = stationID
        self.api = api
    }
}

// MARK:- BoardItemsDownloadProtocol
extension TBoardItemsDownload: BoardItemsDownloadProtocol {
    func download(success: @escaping APIQueryCallback<[BoardItem]>, failure: APIFailureCallback?) {
        let query = TStationBoardQuery(id: self.stationID)
        
        self.api.execute(query, successJSON: { (result) in
            var output = [BoardItem]()
            
            guard let boards = result.first?.value.board else {
                failure?(APIFailure.invalidData)
                return
            }
            
            for board in boards {
                let gps = (board.lag > 50_000) ? true : false
                var delay = 0
                var estimatedMinutes = 0
                
                if board.routeBegin {
                    delay = 0
                    estimatedMinutes = board.minuteCount + Int(board.delay.magnitude)
                } else {
                    delay = board.delay
                    estimatedMinutes = board.minuteCount
                }
                
                let data = BoardItem(line: board.line,
                                     direction: board.direction,
                                     lastStation: board.currentStop.name,
                                     nextStation: board.nextStop.name,
                                     estimatedMinutes: estimatedMinutes,
                                     delay: delay,
                                     scheduledDepartureTime: board.scheduledDepartureTime,
                                     vehicleNumber: board.code,
                                     poorGPS: gps)
                
                output.append(data)
            }
            
            success(output.sorted{ $0.estimatedMinutes < $1.estimatedMinutes })
            
        }) { (reason) in
            failure?(reason)
        }
    }
}
