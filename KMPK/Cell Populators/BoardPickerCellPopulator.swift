//
//  BoardPickerCellPopulator.swift
//  KMPK
//
//  Created by Karol Bukowski on 11.03.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit

final class BoardPickerCellPopulator {
    
}

extension BoardPickerCellPopulator: CollectionCellPopulator {
    typealias Data = BoardPickerData
    
    func populate(collectionView: UICollectionView, indexPath: IndexPath, data: BoardPickerData) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoardPickerCollectionViewCell.cellId, for: indexPath) as? BoardPickerCollectionViewCell else {
            fatalError("Could not dequeue cell \(BoardPickerCollectionViewCell.self)")
        }
        
        cell.dataSource = data.controller.dataSource
        cell.layout = data.controller.flowLayout
        cell.title = data.station.id
        
        data.controller.dataProviderDelegate = cell

        return cell
    }
}
