//
//  BoardPickerCollectionController.swift
//  KMPK
//
//  Created by Karol Bukowski on 17.03.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit

final class BoardPickerCollectionController {
    // MARK:- Private properties
    private let name: String
    private let controller: StationsControllerProtocol
    
    private lazy var stations: [StationData] = {
        return self.controller.get(name: self.name)
    }()
    private lazy var dataProvider: BoardPickerDataProvider = {
        return BoardPickerDataProvider(stations: self.stations)
    }()
    private lazy var cellPopulator: BoardPickerCellPopulator = {
       return BoardPickerCellPopulator()
    }()
    private lazy var dataSource: CollectionDataSource<BoardPickerDataProvider, BoardPickerCellPopulator> = {
        return CollectionDataSource<BoardPickerDataProvider, BoardPickerCellPopulator>(dataProvider: self.dataProvider, cellPopulator: self.cellPopulator)
    }()
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 250, height: 300)
        
        return layout
    }()
    
    // MARK:- Public properties
    private(set) lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        
        collection.register(BoardPickerCollectionViewCell.self, forCellWithReuseIdentifier: BoardPickerCollectionViewCell.cellId)
        
        collection.dataSource = self.dataSource
        //collection.delegate = self.delegate
        
        return collection
    }()

    // MARK:- Initialization
    init(stationName: String, stationsController: StationsControllerProtocol) {
        self.name = stationName
        self.controller = stationsController
    }
}
