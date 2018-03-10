//
//  BoardDataSource.swift
//  KMPK
//
//  Created by Karol Bukowski on 20.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

class BoardItemsDownloader {
    typealias Data = [BoardItem]
    
    // MARK:- Private properties
    private let policyController: DownloaderPolicyController
    private let api: APIProtocol
    
    // MARK:- Initialization
    init(api: APIProtocol, policy: DownloaderPolicyController = DownloaderPolicyController.global) {
        self.api = api
        self.policyController = policy
    }
    
    // MARK:- Public methods
    func download(stationId: String, success: @escaping (Data) -> Void, failure: APIFailureCallback?) {
        let policy = self.policyController.getPolicy(downloader: type(of: self))
        
        switch policy {
        case .mixed:
            mixedPolicy(stationId: stationId, success: success, failure: failure)
        default:
            // should be fatalError(), data source need to be transparent
            failure?(APIFailure.otherError(description: "Not found \(policy) policy", userInfo: nil))
        }
    }
    
    // MARK:- Private methods
    private func mixedPolicy(stationId: String, success: @escaping APIQueryCallback<Data>, failure: APIFailureCallback?) {
        
        let query = TStationBoardQuery(id: stationId)
        
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
