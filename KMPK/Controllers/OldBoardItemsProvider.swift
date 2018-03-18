//
//  BoardDataProvider.swift
//  KMPK
//
//  Created by Karol Bukowski on 03.03.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

protocol OldBoardItemsProviderProtocol: class {
    func boardItemsProvider(stationID id: String) -> [BoardItem]
    func boardItemsProvider(didUpdate: @escaping (_ stationId: String) -> Void)
}

class OldBoardItemsProvider {
    // MARK:- Private properties
    private let controller: BoardController
    private let station: String
    
    private lazy var subscribers = SafeArray<(_ stationId: String) -> Void>()
    private lazy var data = [String : [BoardItem]]()
    
    private lazy var queue = DispatchQueue(label: "com.kb.kmpk.boardItemsProvider", attributes: .concurrent)
    private lazy var timer: DispatchSourceTimer = {
        let timer = DispatchSource.makeTimerSource(queue: queue)
        
        timer.schedule(deadline: .now(), repeating: .seconds(7), leeway: .seconds(1))
        timer.setEventHandler { //TODO weak self
            self.update()
        }
        
        return timer
    }()
    
    // MARK:- Initialization
    init(stationName: String, controller: BoardController) {
        self.station = stationName
        self.controller = controller
        controller.delegate = self
    }
    
    deinit {
        cancel()
    }
    
    // MARK:- Public methods
    func deleteAllSubscribers() {
        self.subscribers.removeAll()
    }
    
    func start() {
        timer.resume()
    }
    
    func cancel() {
        timer.cancel()
    }
    
    // MARK:- Private methods
    private func callSubscribers(id: String) {
        self.subscribers.forEach{ $0(id) }
    }
    
    private func update() {
        self.controller.boards(stationName: self.station)
    }
}

// MARK:- BoardDataProviderProtocol
extension OldBoardItemsProvider: OldBoardItemsProviderProtocol {
    func boardItemsProvider(stationID id: String) -> [BoardItem] {
        guard let data = self.data[id] else {
            return []
        }
        
        return data
    }
    
    func boardItemsProvider(didUpdate subscriber: @escaping (_ stationId: String) -> Void) {
        self.subscribers += subscriber
    }
}

// MARK:- BoardControllerDelegate
extension OldBoardItemsProvider: BoardControllerDelegate {
    func boardController(_ board: [BoardItem], forStation id: String) {
        self.data[id] = board
        callSubscribers(id: id)
    }
}
