//
//  StationsCollectionViewController.swift
//  KMPK
//
//  Created by Karol Bukowski on 24.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit

protocol StationsCollectionViewDataSource: class {
    func shouldUseCompactCell(_ collectionView: UICollectionView) -> Bool
    func highlightNeedle(_ collectionView: UICollectionView) -> String
}

protocol StationsCollectionViewDelegate: class {
    func stationsCollectionView(_ collectionView: UICollectionView, didSelect station: StationData)
}

class StationsCollectionViewController: NSObject {
    // MARK:- Public properties
    weak var dataSource: StationsCollectionViewDataSource?
    weak var delegate: StationsCollectionViewDelegate?

    // MARK:- Private properties
    private var rawDataSource = [StationData]()
    
    private let collectionView: UICollectionView
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        return layout
    }()
    
    // MARK:- Initialization
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView

        super.init()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.collectionViewLayout = self.flowLayout
        
        self.collectionView.register(UINib(nibName: String(describing: StationCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: StationCollectionViewCell.cellId)
    }
    
    // MARK:- Private methods
    private func reloadDataSource(_ newData: [StationData]) {
        let oldValues = saveNewData(newData)
        
        if oldValues.isEmpty {
            self.collectionView.reloadData()
        } else {
            self.collectionView.reloadData(with: BatchUpdates.compare(oldValues: oldValues, newValues: self.rawDataSource))
        }
        
        highlightNeedle()
    }
    
    private func saveNewData(_ data: [StationData]) -> [StationData] {
        let oldValues = self.rawDataSource
        self.rawDataSource = data
        
        guard
            let dataSource = self.dataSource,
            dataSource.shouldUseCompactCell(self.collectionView) == true
        else {
            return oldValues
        }
        
        var compact = [StationData]()
        
        self.rawDataSource.forEach { (item) in
            if !compact.contains(where: { $0.name == item.name }) {
                compact.append(item)
            }
        }
        
        self.rawDataSource = compact
        
        return oldValues
    }
    
    private func highlightNeedle() {
        guard
            let needle = self.dataSource?.highlightNeedle(self.collectionView),
            let cells = self.collectionView.visibleCells as? [StationCollectionViewCell] else {
            return
        }

        for cell in cells {
            cell.highlightNeedle(needle)
        }
    }
}

// MARK:- SearchControllerDelegate
extension StationsCollectionViewController: SearchControllerDelegate {
    func searchController(result: [StationData]) {
        reloadDataSource(result)
    }
}

// MARK:- UICollectionViewDataSource
extension StationsCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.rawDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StationCollectionViewCell.cellId, for: indexPath) as? StationCollectionViewCell else {
            fatalError("Could not dequeue cell \(String(describing: StationCollectionViewCell.self))")
        }
        
        let data = self.rawDataSource[indexPath.row]
        
        cell.stationId = data.id
        cell.stationName = data.name
        
        guard let dataSource = self.dataSource else {
            return cell
        }
        
        cell.isCompact = dataSource.shouldUseCompactCell(collectionView)
        cell.highlightNeedle(dataSource.highlightNeedle(collectionView))
        
        return cell
    }
}

// MARK:- UICollectionViewDelegateFlowLayout
extension StationsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - self.flowLayout.sectionInset.left - self.flowLayout.sectionInset.right - collectionView.contentInset.left - collectionView.contentInset.right - 10
        
        return CGSize(width: width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.stationsCollectionView(collectionView, didSelect: self.rawDataSource[indexPath.row])
    }
}
