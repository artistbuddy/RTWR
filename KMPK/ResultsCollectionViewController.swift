//
//  ResultCollectionViewDataSource.swift
//  KMPK
//
//  Created by Karol Bukowski on 03.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit

protocol ResultsCollectionViewControllerDelegate: class {
    func resultsCollectionViewController(_ controller: ResultsCollectionViewController, didSelectStation station: StationShort)
}

class ResultsCollectionViewController: NSObject {
    weak var delegate: ResultsCollectionViewControllerDelegate?
    
    private var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        return layout
    }()
    let collectionView: UICollectionView
    
    private var dataSource = [StationShort]()
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        
        super.init()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.collectionViewLayout = self.flowLayout
        
    }
}

// MARK:- UICollectionViewDataSource
extension ResultsCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RawDataCollectionViewCell.cellID, for: indexPath) as? RawDataCollectionViewCell else {
            fatalError()
        }
        
        var text = String()
        dump(dataSource[indexPath.row], to: &text)
        
        cell.textView.text = text
        
        return cell
    }
}

// MARK:- UICollectionViewDelegate
extension ResultsCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.resultsCollectionViewController(self, didSelectStation: self.dataSource[indexPath.row])
    }
}

// MARK:- UICollectionViewDelegateFlowLayout
extension ResultsCollectionViewController: UICollectionViewDelegateFlowLayout {
    
}

// MARK:- SearchControllerDelegate
extension ResultsCollectionViewController: SearchControllerDelegate {
    func searchController(_ controller: SearchController, result: [StationShort]) {
        self.dataSource = result
        self.collectionView.reloadData()
    }
}
