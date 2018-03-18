//
//  CollectionDataSource.swift
//  KMPK
//
//  Created by Karol Bukowski on 11.03.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit

class CollectionDataSource<Provider: CollectionDataProvider, Populator: CollectionCellPopulator>: NSObject, UICollectionViewDataSource where Provider.Data == Populator.Data {
    // MARK:- Private properties
    private let provider: Provider
    private let populator: Populator
    
    // MARK:- Initialization
    init(dataProvider: Provider, cellPopulator: Populator) {
        self.provider = dataProvider
        self.populator = cellPopulator
    }
    
    // MARK:- UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.provider.numberOfItems(inSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.populator.populate(collectionView: collectionView, indexPath: indexPath, data: self.provider.itemAt(indexPath: indexPath))
    }
}

