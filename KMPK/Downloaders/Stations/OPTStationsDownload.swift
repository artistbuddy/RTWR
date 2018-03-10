//
//  OPTStationsDownload.swift
//  KMPK
//
//  Created by Karol Bukowski on 10.03.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

class OPTStationsDownload {
    // MARK:- Private properties
    private let api: APIProtocol
    
    // MARK:- Initialization
    init(api: APIProtocol) {
        self.api = api
    }
}

// MARK:- StationsDownloadProtocol
extension OPTStationsDownload: StationsDownloadProtocol {
    func download(success: @escaping ([StationData]) -> Void, failure: APIFailureCallback?) {
        let tquery = TAllStationsQuery()
        let opquery = OPStationLocationsQuery()
        
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
