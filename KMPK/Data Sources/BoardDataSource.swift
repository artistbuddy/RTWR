//
//  BoardDataSource.swift
//  KMPK
//
//  Created by Karol Bukowski on 20.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

protocol BoardData {
    var line: String { get }
    var direction: String { get }
    var lastStation: String { get }
    var nextStation: String { get }
    var estimatedMinutes: Int { get }
    var delay: Int { get }
    var scheduledDepartureTime: String { get }
    var vehicleNumber: Int { get }
    var poorGPS: Bool { get }
}

fileprivate struct ResultData: BoardData {
    var line: String
    var direction: String
    var lastStation: String
    var nextStation: String
    var estimatedMinutes: Int
    var delay: Int
    var scheduledDepartureTime: String
    var vehicleNumber: Int
    var poorGPS: Bool
    
    static let empty = ResultData(line: "",
                                  direction: "",
                                  lastStation: "",
                                  nextStation: "",
                                  estimatedMinutes: 0,
                                  delay: 0,
                                  scheduledDepartureTime: "",
                                  vehicleNumber: 0,
                                  poorGPS: false)
}

class BoardDataSource {
    typealias Data = [BoardData]
    
    let policyController: DataSourcePolicyController
    let api: APIProtocol
    
    init(api: APIProtocol, policy: DataSourcePolicyController = DataSourcePolicyController.global) {
        self.api = api
        self.policyController = policy
    }
    
    func download(stationId: String, success: @escaping (Data) -> Void, failure: APIFailureCallback?) {
        let policy = self.policyController.getPolicy(dataSource: type(of: self))
        
        switch policy {
        case .mixed:
            mixedPolicy(stationId: stationId, success: success, failure: failure)
        default:
            // should be fatalError(), data source need to be transparent
            failure?(APIFailure.otherError(description: "Not found \(policy) policy", userInfo: nil))
        }
    }
    
    private func mixedPolicy(stationId: String, success: @escaping APIQueryCallback<Data>, failure: APIFailureCallback?) {
        
        let query = TStationBoardQuery(id: stationId)
        
        self.api.execute(query, successJSON: { (result) in            
            var output = [ResultData]()
            
            guard let boards = result.first?.value.board else {
                failure?(APIFailure.invalidData)
                return
            }
                
            for board in boards {
                var data = ResultData.empty
                
                data.line = board.line
                data.direction = board.direction
                data.lastStation = board.currentStop.name
                data.nextStation = board.nextStop.name
                data.vehicleNumber = board.code
                data.scheduledDepartureTime = board.scheduledDepartureTime
                data.poorGPS = (board.lag > 50_000) ? true : false
                data.delay = (board.delay < 0) ? 0 : board.delay
                
                if board.routeBegin {
                    data.delay = 0
                    data.estimatedMinutes = board.minuteCount + Int(board.delay.magnitude)
                } else {
                    data.delay = board.delay
                    data.estimatedMinutes = board.minuteCount
                }
                
                output.append(data)
            }
            
            success(output.sorted{ $0.estimatedMinutes < $1.estimatedMinutes })
            
        }) { (reason) in
            failure?(reason)
        }
        
    }
    
}
