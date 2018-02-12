//
//  DetailsCollectionViewController.swift
//  KMPK
//
//  Created by Karol Bukowski on 03.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit

class DetailsCollectionViewController: NSObject {
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        return layout
    }()
    let collectionView: UICollectionView
    
    private var dataSource = [BoardData]()
    
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
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsNormalCollectionViewCell.cellID, for: indexPath) as? DetailsNormalCollectionViewCell else {
            fatalError()
        }
        
        let data = self.dataSource[indexPath.row]
        
        cell.cellWidth = self.collectionView.frame.width - 50
        cell.airConditioningLabel.isHidden = !(data.airConditioning)
        cell.disabledFacilitiesLabel.isHidden = !(data.disabledFacilities)
        cell.directionLabel.text = data.direction
        cell.lineLabel.text = data.line
        cell.lastStopLabel.text = data.lastStop
        cell.estimatedMinutesLabel.text = String(describing: data.estimatedMinutes)
        
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
    func stationController(_ controller: StationController, station: [BoardData]) {
        self.dataSource = station
        self.collectionView.reloadData()
    }
}
