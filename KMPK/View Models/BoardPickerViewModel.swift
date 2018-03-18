//
//  BoardPickerViewModel.swift
//  KMPK
//
//  Created by Karol Bukowski on 05.03.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit

class BoardPickerViewModel {
    let controller: BoardPickerCollectionController
    
    init(controller: BoardPickerCollectionController) {
        self.controller = controller
    }
}

// MARK:- CollectionViewModelProtocol
extension BoardPickerViewModel: CollectionViewModelProtocol {
    var collection: UICollectionView {
        return self.controller.collectionView
    }
}
