//
//  BoardPreviewCellPopulator.swift
//  KMPK
//
//  Created by Karol Bukowski on 11.03.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit

final class BoardPreviewCellPopulator {

}

extension BoardPreviewCellPopulator: CollectionCellPopulator {
    typealias Data = BoardItem
    
    func populate(collectionView: UICollectionView, indexPath: IndexPath, data: BoardItem) -> UICollectionViewCell {        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoardPreviewCollectionViewCell.cellId, for: indexPath) as? BoardPreviewCollectionViewCell else {
            fatalError("Could not dequeue cell \(BoardPreviewCollectionViewCell.self)")
        }
        
        cell.minutes = data.estimatedMinutes
        cell.line = data.line + " " + data.direction
        cell.isLive = !(data.poorGPS ?? false)
        
        return cell
    }
    
    
}
