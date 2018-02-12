//
//  SearchController.swift
//  KMPK
//
//  Created by Karol Bukowski on 03.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit

protocol SearchResultData {
    typealias Line = String
    typealias Direction = String
    
    var id: String { get }
    var name: String { get }
    var routes: [Direction : Line] { get }
}

fileprivate struct ResultData: SearchResultData {
    var id: String
    var name: String
    var routes: [Direction : Line]
    
    init(id: String, name: String, routes: [Direction : Line]) {
        self.id = id
        self.name = name
        self.routes = routes
    }
}

protocol SearchControllerDelegate: class {
    func searchController(_ controller: SearchController, result: [SearchResultData])
}

class SearchController: NSObject {
    weak var delegate: SearchControllerDelegate?
    
    func search(query: String) {
        let query = TSearchStationQuery(query: query)

        Session.api.execute(query, successJSON: { [weak self] (result) in
            
            let parsed = self?.parseSearch(result: result)
            
            DispatchQueue.main.async {
                self?.delegate?.searchController(self!, result: parsed!)
            }
            
        }) { (error) in
            APILog.debug(error)
        }
    }
    
    private func parseSearch(result: TSearchStationQuery.Result) -> [ResultData] {
        var output = [ResultData]()

        for station in result {
            var routes = [String : String]()
            
            for line in station.lines {
                
                if routes[line.direction] != nil {
                    routes[line.direction]!.append("; \(line.line)")
                } else {
                    routes[line.direction] = line.line
                }
                
            }
            
            let data = ResultData(id: station.symbol, name: station.name, routes: routes)
            
            output.append(data)
        }
        
        return output
    }
}


