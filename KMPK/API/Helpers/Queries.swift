//
//  Queries.swift
//  KMPK
//
//  Created by Karol Bukowski on 03.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

// MARK: - Tram source queries
struct TSearchStationQuery: APIJSONQuery {
    typealias Result = [TStationShort]
    
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

struct TAllStationsQuery: APIJSONQuery {
    typealias Result = [TStationShort]
    
    var parameters: [String : String]? {
        return ["term" : "+++"]
    }
    var path: String {
        return "/ws/board/post/"
    }
    var router: APIRouter
    
    init(router: APIRouter = APIConfig.tram) {
        self.router = router
    }
}

struct TStationBoardQuery: APIJSONQuery {
    typealias Result = [Int : TStationBoard]
    
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

// MARK: - iMPK source queries

// MARK: - Open Data source queries
struct OPLivePositionsQuery: APICSVQuery {    
    typealias Result = [OPLivePositions]
    var path: String = "/datastore/dump/17308285-3977-42f7-81b7-fdd168c210a2"
    var parameters: [String : String]? = nil
    var router: APIRouter = APIConfig.op
}

struct OPStationPositionsQuery: APICSVQuery {
    typealias Result = [OPStationPositions]
    var path: String = "/dataset/e3002397-f22b-4aa1-a7eb-bc70af83dba0/resource/003e5b6a-233d-4ad4-bac5-9bf96bc05ccc/download/slupkiwspolrzedne.csv"
    var parameters: [String : String]? = nil
    var router: APIRouter = APIConfig.op
}
