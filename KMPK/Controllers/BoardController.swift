//
//  BoardController.swift
//  KMPK
//
//  Created by Karol Bukowski on 01.03.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

protocol BoardControllerDelegate: class {
    func boardController(_ board: [BoardData], forStation id: String)
}

protocol BoardControllerProtocol {
    func board(forStation id: String)
    func boards(forStations ids: [String])
}

class BoardController {
    // MARK:- Public properties
    weak var delegate: BoardControllerDelegate?
    
    // MARK:- Private properties
    private let dataSource: BoardDataSource
    
    // MARK:- Initialization
    init(dataSource: BoardDataSource) {
        self.dataSource = dataSource
    }
}

// MARK:- BoardControllerProtocol
extension BoardController: BoardControllerProtocol {
    func board(forStation id: String) {
        self.dataSource.download(stationId: id, success: { (result) in
            self.delegate?.boardController(result, forStation: id)
        }, failure: nil)
    }
    
    func boards(forStations ids: [String]) {
        for id in ids {
            board(forStation: id)
        }
    }
}
