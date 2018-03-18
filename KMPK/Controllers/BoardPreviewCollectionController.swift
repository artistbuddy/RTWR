//
//  BoardPreviewCollectionController.swift
//  KMPK
//
//  Created by Karol Bukowski on 17.03.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit

class BoardPreviewCollectionController {
    // MARK:- Private properties
    private let id: String
    
    private lazy var downloader: BoardItemsDownloadProtocol = {
        do {
            let downloader = try BoardItemsDownloader()
                .stationID(self.id)
                .continouesDownload(true) // FIXME set true
                .useCache(false) // FIXME set true
                .build()
            return downloader
        } catch let error {
            fatalError()
        }
    }()
    private lazy var dataProvider: BoardItemsDataProvider = {
        return BoardItemsDataProvider(downloader: self.downloader)
    }()
    private lazy var cellPopulator: BoardPreviewCellPopulator = {
        return BoardPreviewCellPopulator()
    }()
    
    // MARK:- Public properties
    private(set) lazy var dataSource: CollectionDataSource<BoardItemsDataProvider, BoardPreviewCellPopulator> = {
        return CollectionDataSource<BoardItemsDataProvider, BoardPreviewCellPopulator>(dataProvider: self.dataProvider, cellPopulator: self.cellPopulator)
    }()
    private(set) lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 200, height: 100)
        
        return layout
    }()
    
    weak var dataProviderDelegate: BoardItemsDataProviderDelegate? {
        didSet {
            self.dataProvider.delegate = self.dataProviderDelegate
        }
    }
    
    /*
    private(set) lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        
        collection.backgroundColor = UIColor.brown
        
        collection.register(BoardPreviewCollectionViewCell.self, forCellWithReuseIdentifier: BoardPreviewCollectionViewCell.cellId)
        
        collection.dataSource = self.dataSource
        //collection.delegate = self.delegate
        
        return collection
    }()
    */
    
    // MARK:- Initialization
    init(stationID id: String) {
        self.id = id
    }
    
}
