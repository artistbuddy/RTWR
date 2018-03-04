//
//  BoardDataProvider.swift
//  KMPK
//
//  Created by Karol Bukowski on 03.03.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

protocol BoardDataProviderProtocol {
    func boardDataProvider(stationID id: String) -> [BoardData]
    func boardDataProvider(didUpdate: @escaping (_ stationId: String) -> Void)
}

class BoardDataProvider {
    // MARK:- Private properties
    private lazy var subscribers = SafeArray<(_ stationId: String) -> Void>()
    private lazy var data = [String : [BoardData]]()
    
    // MARK:- Private methods
    private func callSubscribers(id: String) {
        self.subscribers.forEach{ $0(id) }
    }
}

// MARK:- BoardDataProviderProtocol
extension BoardDataProvider: BoardDataProviderProtocol {
    func boardDataProvider(stationID id: String) -> [BoardData] {
        guard let data = self.data[id] else {
            return []
        }
        
        return data
    }
    
    func boardDataProvider(didUpdate subscriber: @escaping (_ stationId: String) -> Void) {
        self.subscribers += subscriber
    }
}

// MARK:- BoardControllerDelegate
extension BoardDataProvider: BoardControllerDelegate {
    func boardController(_ board: [BoardData], forStation id: String) {
        self.data[id] = board
        callSubscribers(id: id)
    }
}
