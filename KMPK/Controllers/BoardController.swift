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
    private let downloader: BoardItemsDownloader
    private let controller: StationsController
    
    // MARK:- Initialization
    init(downloader: BoardItemsDownloader, controller: StationsController) {
        self.downloader = downloader
        self.controller = controller
    }
}

// MARK:- BoardControllerProtocol
extension BoardController: BoardControllerProtocol {
    func board(stationID id: String) {
        self.downloader.download(stationId: id, success: { (result) in
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
