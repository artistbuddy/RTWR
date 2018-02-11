//
//  Codables.swift
//  KMPK
//
//  Created by Karol Bukowski on 28.01.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

// MARK:- JSON
struct StationBoard: Codable {
    let name: String
    let direction: String
    let id: String
    let board: [BoardDetails]
}

struct BoardDetails: Codable {
    let line: String
    let minuteCount: Int
    let routeBegin: Bool
    let code: Int
    let direction: String
    let distance: Int
    let floor: String
    let ac: Bool
    let lag: Int
    let delay: Int
    let departure: String
    let scheduledDeparture: String
    let scheduledDepartureTime: String
    let currentStop: StationDetails
    let nextStop: StationDetails
}

struct StationDetails: Codable {
    let s: String
    let x: Double
    let y: Double
    let t: String
    let n: String
    let symbol: String
    let name: String
}

struct StationLines: Codable {
    let line: String
    let direction: String
}

struct StationShort: Codable {
    let symbol: String
    let name: String
    let lines: [StationLines]
}

// MARK:- CSV
struct OPLivePositions {
    let id: Int
    let vehicle: Int
    let plate: String
    let squad: String
    let line: String
    let lat: Double
    let long: Double
    let updateDate: Date
}

struct OPStationPositions {
    let id: Int
    let type: String
    let lat: Double
    let long: Double
}
