//
//  BoardData.swift
//  KMPK
//
//  Created by Karol Bukowski on 01.03.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

struct BoardData {
    let line: String
    let direction: String
    let lastStation: String
    let nextStation: String
    let estimatedMinutes: Int
    let delay: Int
    let scheduledDepartureTime: String
    let vehicleNumber: Int
    let poorGPS: Bool?
    
    init(line: String, direction: String, lastStation: String, nextStation: String, estimatedMinutes: Int, delay: Int, scheduledDepartureTime: String, vehicleNumber: Int, poorGPS: Bool?){
        self.line = line
        self.direction = direction
        self.lastStation = lastStation
        self.nextStation = nextStation
        self.estimatedMinutes = estimatedMinutes
        self.delay = delay
        self.scheduledDepartureTime = scheduledDepartureTime
        self.vehicleNumber = vehicleNumber
        self.poorGPS = poorGPS
    }
}
