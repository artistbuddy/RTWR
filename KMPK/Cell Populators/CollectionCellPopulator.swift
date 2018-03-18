//
//  CollectionCellPopulator.swift
//  KMPK
//
//  Created by Karol Bukowski on 11.03.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit

protocol CollectionCellPopulator: class {
    associatedtype Data
    
    func populate(collectionView: UICollectionView, indexPath: IndexPath, data: Data) -> UICollectionViewCell
}
