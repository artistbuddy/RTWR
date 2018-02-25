//
//  StationCoordinates.swift
//  KMPK
//
//  Created by Karol Bukowski on 24.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

struct StationCoordinates {
    let latitude: Double
    let longitute: Double
    
    init(lat: Double, long: Double) {
        self.latitude = lat
        self.longitute = long
    }
}
