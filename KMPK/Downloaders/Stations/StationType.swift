//
//  StationType.swift
//  KMPK
//
//  Created by Karol Bukowski on 24.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

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
