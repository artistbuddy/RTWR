//
//  StationData.swift
//  KMPK
//
//  Created by Karol Bukowski on 24.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

struct StationData {
    let id: String
    let name: String
    let type: StationType
    let coordinates: StationCoordinates
    let routes: [StationRoute]
    
    init(id: String, name: String, type: StationType, coordinates: StationCoordinates, routes: [StationRoute]) {
        self.id = id
        self.name = name
        self.type = type
        self.coordinates = coordinates
        self.routes = routes
    }
    
    init(core: CoreStation) {
        self.id = core.id
        self.name = core.name
        self.type = StationType(int16: core.type)!
        self.coordinates = StationCoordinates(lat: core.latitude, long: core.longitude)
        self.routes = Array(core.routes.map{ StationRoute(core: $0) })
    }
}

// MARK:- Equatable
extension StationData: Equatable  {
    static func ==(lhs: StationData, rhs: StationData) -> Bool {
        return lhs.id == rhs.id
    }
}
