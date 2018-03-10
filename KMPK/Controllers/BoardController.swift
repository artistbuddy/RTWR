//
//  BoardController.swift
//  KMPK
//
//  Created by Karol Bukowski on 01.03.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

protocol BoardControllerDelegate: class {
    func boardController(_ board: [BoardItem], forStation id: String)
}

protocol BoardControllerProtocol {
    func board(stationID id: String)
    func boards(stationIDs ids: [String])
    func boards(stationName name: String)
}

class BoardController {
    // MARK:- Public properties
    weak var delegate: BoardControllerDelegate?
    
    // MARK:- Private properties
    private let controller: StationsController
    
    // MARK:- Initialization
    init(controller: StationsController) {
        self.controller = controller
    }
}

// MARK:- BoardControllerProtocol
extension BoardController: BoardControllerProtocol {
    func board(stationID id: String) {
        try? BoardItemsDownloader().setAPI(Session.shared.api).stationID(id).useCache(false).build().download(success: { (result) in
            self.delegate?.boardController(result, forStation: id)
        }, failure: nil)
    }
    
    func boards(stationIDs ids: [String]) {
        for id in ids {
            board(stationID: id)
        }
    }
    
    func boards(stationName name: String) {
        let stations = self.controller.get(name: name)
        boards(stationIDs: stations.map{ $0.id })
    }
}
