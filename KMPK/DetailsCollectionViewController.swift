//
//  DetailsCollectionViewController.swift
//  KMPK
//
//  Created by Karol Bukowski on 03.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit

class DetailsCollectionViewController: NSObject {
    private var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        return layout
    }()
    let collectionView: UICollectionView
    
    private var dataSource = [BoardDetails]()
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        
        super.init()
        
        self.collectionView.dataSource = self
        self.collectionView.collectionViewLayout = self.flowLayout
    }
}

// MARK:- UICollectionViewDataSource
extension DetailsCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RawDataCollectionViewCell.cellID2, for: indexPath) as? RawDataCollectionViewCell else {
            fatalError()
        }
        
        var text = String()
        dump(dataSource[indexPath.row], to: &text)
        
        cell.textView.text = text
        
        return cell
    }
}

// MARK:- UICollectionViewDelegate
extension DetailsCollectionViewController: UICollectionViewDelegate {
    
}

// MARK:- UICollectionViewDelegateFlowLayout
extension DetailsCollectionViewController: UICollectionViewDelegateFlowLayout {
    
}

// MARK:- StationControllerDelegate
extension DetailsCollectionViewController: StationControllerDelegate {
    func stationController(_ controller: StationController, board: [BoardDetails]) {
        self.dataSource = board
        self.collectionView.reloadData()
    }
}
