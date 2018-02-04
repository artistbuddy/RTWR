//
//  SearchController.swift
//  KMPK
//
//  Created by Karol Bukowski on 03.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit

protocol SearchQueryResult {
    typealias Line = String
    typealias Direction = String
    
    var stationID: String { get }
    var stationName: String { get }
    var routes: [Direction : Line] { get }
}

struct SearchResultData: SearchQueryResult {
    var stationID: String
    var stationName: String
    var routes: [Direction : Line]
    
    init(id: String, name: String, routes: [Direction : Line]) {
        self.stationID = id
        self.stationName = name
        self.routes = routes
    }
}

protocol SearchControllerDelegate: class {
    func searchController(_ controller: SearchController, result: [SearchQueryResult])
}

class SearchController: NSObject {
    weak var delegate: SearchControllerDelegate?
    
    func search(query: String) {
        let query = SearchStationQuery(query: query)
        
        APIController.shared.execute(query, success: { [weak self] (result) in
            
            let parsed = self?.parseSearch(result: result)
            
            DispatchQueue.main.async {
                self?.delegate?.searchController(self!, result: parsed!)
            }
            
        }) { (error) in
            Log.debug(error)
        }
    }
    
    private func parseSearch(result: SearchStationQuery.Result) -> [SearchResultData] {
        var output = [SearchResultData]()

        for station in result {
            var routes = [String : String]()
            
            for line in station.lines {
                
                if routes[line.direction] != nil {
                    routes[line.direction]!.append("; \(line.line)")
                } else {
                    routes[line.direction] = line.line
                }
                
            }
            
            let data = SearchResultData(id: station.symbol, name: station.name, routes: routes)
            
            output.append(data)
        }
        
        return output
    }
}


