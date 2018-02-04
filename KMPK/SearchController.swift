//
//  SearchController.swift
//  KMPK
//
//  Created by Karol Bukowski on 03.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit

protocol SearchControllerDelegate: class {
    func searchController(_ controller: SearchController, result: [StationShort])
}

class SearchController: NSObject {
    weak var delegate: SearchControllerDelegate?
    
    func search(query: String) {
        let query = SearchStationQuery(query: query)
        
        APIController.shared.execute(query, success: { [weak self] (result) in
            DispatchQueue.main.async {
                self?.delegate?.searchController(self!, result: result)
            }
        }) { (error) in
            Log.debug(error)
        }
    }
}


