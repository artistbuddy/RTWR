//
//  StationController.swift
//  KMPK
//
//  Created by Karol Bukowski on 03.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

protocol StationControllerDelegate: class {
    func stationController(_ controller: StationController, board: [BoardDetails])
}

class StationController {
    weak var delegate: StationControllerDelegate?
    
    func show(id: String) {
        let query = StationBoardQuery(id: id)
        
        APIController.shared.execute(query, success: { [weak self] (results) in
            let board = results.first!.value.board
            
            DispatchQueue.main.async {
                self?.delegate?.stationController(self!, board: board)
            }
        }) { (error) in
            Log.debug(error)
        }
        
    }
}
