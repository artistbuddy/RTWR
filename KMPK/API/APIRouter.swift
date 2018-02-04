//
//  APIRouter.swift
//  KMPK
//
//  Created by Karol Bukowski on 28.01.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

enum APIRouter: APIConfig {
    case tram
    
    var baseURL: URL {
        switch self {
        case .tram:
            return URL(string: "http://tram.wroclaw.pl")!
        }
    }
}
