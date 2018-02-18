//
//  StationDataSource.swift
//  KMPK
//
//  Created by Karol Bukowski on 12.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

struct Coordinates {
    let latitude: Double
    let longitute: Double
    
    init(lat: Double, long: Double) {
        self.latitude = lat
        self.longitute = long
    }
}

enum StationType {
    case tram, bus, both
    
    init?(t: String) {
        switch t {
        case "0": self = .tram
        case "3": self = .bus
        case "03": self = .both
        default: return nil
        }
    }
    
    init?(int16: Int16) {
        switch int16 {
        case 1: self = .tram
        case 2: self = .bus
        case 3: self = .both
        default: return nil
        }
    }
    
    var toInt16: Int16 {
        switch self {
        case .tram: return 1
        case .bus: return 2
        case .both: return 3
        }
    }
}

protocol StationData {
    var id: String { get }
    var name: String { get }
    var type: StationType { get }
    var coordinates: Coordinates { get }
    var routes: [StationRoute] { get }
}

protocol StationRoute {
    var line: String { get }
    var direction: String { get }
}

fileprivate struct ResultData: StationData {
    var id: String = ""
    var name: String = ""
    var type: StationType = .bus
    var coordinates: Coordinates = Coordinates(lat: 0, long: 0)
    var routes: [StationRoute] = []
}

fileprivate struct RouteData {
    var line: String = ""
    var direction: String = ""
}

class StationDataSource: DataSourceDownloader {
    typealias Data = [StationData]
    
    let policy: DataSourcePolicy
    let api: APIProtocol
    
    init(api: APIProtocol, policy: DataSourcePolicy = DataSourcePolicyController.global.defaultPolicy) {
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
            
            var output = [ResultData]()
            
            for t in tdata {
                
                if let index = opdata.index(where: { String(describing: $0.id) == t.symbol }) {
                    let op = opdata[index]
                    opdata.remove(at: index)
                    
                    guard let type = StationType(t: op.type) else {
                        APILog.debug("StationDataSource invalid op data \(op)")
                        break
                    }
                    
                    let result = ResultData(id: t.symbol, name: t.name, type: type, coordinates: Coordinates(lat: op.lat, long: op.long), routes: t.lines)
                    output.append(result)
                    
                } else {
                    APILog.debug("StationDataSource not found op station \(t.symbol)")
                }
            }

            success(output)
        }
    }
}
