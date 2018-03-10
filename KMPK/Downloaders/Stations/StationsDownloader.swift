//
//  StationDataSource.swift
//  KMPK
//
//  Created by Karol Bukowski on 12.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

class StationsDownloader {
    typealias Data = [StationData]
    
    let policy: DownloaderPolicy
    let api: APIProtocol
    
    init(api: APIProtocol, policy: DownloaderPolicy = DownloaderPolicyController.global.defaultPolicy) {
        self.api = api
        self.policy = policy
    }
    
    func download(success: @escaping (Data) -> Void, failure: APIFailureCallback?) {
        switch policy {
        case .mixed:
            mixedPolicy(success: success, failure: failure)
        default:
            // should be fatalError(), data source need to be transparent
            failure?(APIFailure.otherError(description: "Not found \(policy) policy", userInfo: nil))
        }
    }

    private func mixedPolicy(success: @escaping APIQueryCallback<Data>, failure: APIFailureCallback?) {
        let tquery = TAllStationsQuery()
        let opquery = OPStationPositionsQuery()
        
        var tdata: [TStationShort]?
        var opdata: [OPStationPositions]?
        
        let group = DispatchGroup()
        
        group.enter()
        self.api.execute(tquery, successJSON: { (result) in
            tdata = result
            group.leave()
        }) { (reason) in
            failure?(reason)
            group.leave()
        }
        
        group.enter()
        self.api.execute(opquery, successCSV: { (result) in
            opdata = result
            group.leave()
        }) { (reason) in
            failure?(reason)
            group.leave()
        }
        
        group.notify(queue: .global(qos: .background)) {
            guard let tdata = tdata, var opdata = opdata else {
                failure?(APIFailure.invalidData)
                return
            }
            
            var output = [StationData]()
            
            for t in tdata {
                
                if let index = opdata.index(where: { String(describing: $0.id) == t.symbol }) {
                    let op = opdata[index]
                    opdata.remove(at: index)
                    
                    guard let type = StationType(t: op.type) else {
                        APILog.debug("StationDataSource invalid op data \(op)")
                        break
                    }
                    
                    let result = StationData(id: t.symbol, name: t.name, type: type, coordinates: StationCoordinates(lat: op.lat, long: op.long), routes: t.lines.map{ StationRoute(t: $0) })
                    output.append(result)
                    
                } else {
                    APILog.debug("StationDataSource not found op station \(t.symbol)")
                }
            }

            success(output)
        }
    }
}
