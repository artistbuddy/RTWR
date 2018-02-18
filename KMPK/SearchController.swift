//
//  SearchController.swift
//  KMPK
//
//  Created by Karol Bukowski on 03.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit
import CoreData

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
        var output = [SearchResultData]()
        
        let context = Session.shared.database.readContext
        
        let request: NSFetchRequest<CoreStation> = CoreStation.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", query)
        
        do {
            let results = try context.fetch(request)
            
            for data in results {
                var routes = [String : String]()
                for r in data.routes {
                    routes[r.line] = r.direction
                }

                let search = ResultData(id: data.id,
                                        name: data.name,
                                        routes: routes)
                
                output.append(search)
            }
            
        } catch {
            print("Failed")
        }
        
        delegate?.searchController(self, result: output)
        
    }
}


