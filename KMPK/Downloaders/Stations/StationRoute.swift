//
//  StationRoute.swift
//  KMPK
//
//  Created by Karol Bukowski on 24.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

struct StationRoute {
    var line: String
    var direction: String
    
    init(line: String, direction: String) {
        self.line = line
        self.direction = direction
    }
    
    init(core: CoreStationRoute) {
        self.line = core.line
        self.direction = core.direction
    }
    
    init(t: TStationLines) {
        self.line = t.line
        self.direction = t.direction
    }
}
