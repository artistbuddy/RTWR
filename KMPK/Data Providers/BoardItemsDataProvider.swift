//
//  BoardItemsDataProvider.swift
//  KMPK
//
//  Created by Karol Bukowski on 11.03.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

protocol BoardItemsDataProviderDelegate: class {
    func boardItemsDataProvider(didUpdate batchUpdates: BatchUpdates)
}

class BoardItemsDataProvider {
    // MARK:- Public properties
    weak var delegate: BoardItemsDataProviderDelegate?
    
    // MARK:- Private properties
    private let downloader: BoardItemsDownloadProtocol
    private var dataSource = [BoardItem]()
    
    // MARK:- Initialization
    init(downloader: BoardItemsDownloadProtocol) {
        self.downloader = downloader
        
        downloader.download(success: { [weak self] (result) in
            self?.reloadData(newData: result)
        }, failure: nil)
    }
    
    // MARK:- Private methods
    private func reloadData(newData: [BoardItem]) {
        let oldData = self.dataSource
        self.dataSource = newData
        
        self.delegate?.boardItemsDataProvider(didUpdate: BatchUpdates.compare(oldValues: oldData, newValues: newData))
    }
    
}

// MARK:- CollectionDataProvider
extension BoardItemsDataProvider: CollectionDataProvider {
    typealias Data = BoardItem
    
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
    
    func itemAt(indexPath: IndexPath) -> BoardItem {
        return self.dataSource[indexPath.row]
    }
}
