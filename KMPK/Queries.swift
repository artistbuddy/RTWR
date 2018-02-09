//
//  Queries.swift
//  KMPK
//
//  Created by Karol Bukowski on 03.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

struct SearchStationQuery: APIJSONQuery {
    typealias Result = [StationShort]
    
    var parameters: [String : String]? {
        return ["term" : self.query]
    }
    var path: String {
        return "/ws/board/post/"
    }
    var router: APIRouter
    
    private let query: String
    
    init(query: String, router: APIRouter = APIConfig.tram) {
        self.router = router
        self.query = query
    }
}

struct StationBoardQuery: APIJSONQuery {
    typealias Result = [Int : StationBoard]
    
    var parameters: [String : String]? = nil
    var path: String {
        return "/ws/board/show/" + self.id
    }
    var router: APIRouter
    
    private let id: String
    
    init(id: String, router: APIRouter = APIConfig.tram) {
        self.router = router
        self.id = id
    }
}
