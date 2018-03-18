//
//  BoardPickerDataProvider.swift
//  KMPK
//
//  Created by Karol Bukowski on 11.03.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

struct BoardPickerData {
    let controller: BoardPreviewCollectionController
    let station: StationData
}

class BoardPickerDataProvider {
    // MARK:- Private properties
    private let stations: [StationData]
    private lazy var dataSource: [BoardPickerData] = {
        var dataSource = [BoardPickerData]()
        
        for station in self.stations {
            let controller = BoardPreviewCollectionController(stationID: station.id)
            let data = BoardPickerData(controller: controller, station: station)
            
            dataSource.append(data)
        }
        
        return dataSource
    }()
    
    // MARK:- Initialization
    init(stations: [StationData]) {
        self.stations = stations
    }
}

// MARK:- CollectionDataProvider
extension BoardPickerDataProvider: CollectionDataProvider {
    typealias Data = BoardPickerData
    
    func numberOfItems() -> Int {
        return self.dataSource.count
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        assert(section == 0)
        return self.dataSource.count
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func itemAt(indexPath: IndexPath) -> BoardPickerData {
        return self.dataSource[indexPath.row]
    }
    
}
