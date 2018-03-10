//
//  SearchController.swift
//  KMPK
//
//  Created by Karol Bukowski on 03.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit
import CoreData

protocol SearchControllerDelegate: class {
    func searchController(result: [StationData])
}

class SearchController {
    // MARK:- Public properties
    weak var delegate: SearchControllerDelegate?
    
    // MARK:- Private properties
    private let controller: StationsControllerProtocol
    private var pendingSearch: DispatchWorkItem?
    
    // MARK:- Initialization
    init(stationController controller: StationsController) {
        self.controller = controller
    }
    
    // MARK:- Public methods
    func search(query: String) {
        self.pendingSearch?.cancel()

        let searchRequest = DispatchWorkItem {
            var result: [StationData]?

            if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: query)) {
                result = self.controller.search(id: query)
            } else {
                result = self.controller.search(name: query)
            }

            self.delegate?.searchController(result: result ?? [])
        }

        self.pendingSearch = searchRequest

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200), execute: searchRequest)

    }
}



