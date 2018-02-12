//
//  ResultCollectionViewDataSource.swift
//  KMPK
//
//  Created by Karol Bukowski on 03.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit

protocol ResultsCollectionViewControllerDelegate: class {
    func resultsCollectionViewController(_ controller: ResultsCollectionViewController, didSelectResult result: StationData)
}

class ResultsCollectionViewController: NSObject {
    weak var delegate: ResultsCollectionViewControllerDelegate?
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        
        return layout
    }()
    let collectionView: UICollectionView
    
    private var dataSource = [StationData]()
    
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
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.cellID, for: indexPath) as? SearchResultCollectionViewCell else {
            fatalError()
        }
        
        let data = self.dataSource[indexPath.row]
        
        cell.cellWidth = self.collectionView.frame.width - 50
        cell.nameLabel.text = data.stationName
        cell.numberLabel.text = data.stationID
        
        cell.routesLabel.attributedText = prepare(routes: data.routes)
        
        return cell
    }
    
    private func prepare(routes: [String : String]) -> NSAttributedString {
        let output = NSMutableAttributedString()
        
        var regularFont: [NSAttributedStringKey : Any] {
            return [
                NSAttributedStringKey.font: UIFont(name: "HelveticaNeue", size: 14),
                NSAttributedStringKey.foregroundColor: UIColor.black
            ]
        }
        
        var mediumFont: [NSAttributedStringKey : Any] {
            return [
                NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Medium", size: 14),
                NSAttributedStringKey.foregroundColor: UIColor.black
            ]
        }
        
        for (offset: index, element: (key: direction, value: line)) in routes.enumerated() {
            let direction = NSAttributedString(string: "\(direction): ", attributes: mediumFont)
            let line = NSAttributedString(string: "\(line)", attributes: regularFont)
            
            output.append(direction)
            output.append(line)
            
            if index < routes.count - 1 {
                output.append(NSAttributedString(string: "\n"))
            }
        }
        
        return output
    }
}

// MARK:- UICollectionViewDelegate
extension ResultsCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.resultsCollectionViewController(self, didSelectResult: self.dataSource[indexPath.row])
    }
}

// MARK:- UICollectionViewDelegateFlowLayout
extension ResultsCollectionViewController: UICollectionViewDelegateFlowLayout {
}

// MARK:- SearchControllerDelegate
extension ResultsCollectionViewController: SearchControllerDelegate {
    func searchController(_ controller: SearchController, result: [StationData]) {
        self.dataSource = result
        self.collectionView.reloadData()
    }
}
