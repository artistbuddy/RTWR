//
//  Queries.swift
//  KMPK
//
//  Created by Karol Bukowski on 03.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

struct SearchStationQuery: APIQuery {
    typealias Result = [StationShort]
    
    var parameters: [String : String]? {
        return ["term" : self.query]
    }
    var path: String {
        return "ws/board/post/"
    }
    
    private let query: String
    
    init(query: String) {
        self.query = query
    }
}

struct StationBoardQuery: APIQuery {
    typealias Result = [Int : StationBoard]
    
    var parameters: [String : String]? = nil
    var path: String {
        return "ws/board/show/" + self.id
    }
    
    private let id: String
    
    init(id: String) {
        self.id = id
    }
}
