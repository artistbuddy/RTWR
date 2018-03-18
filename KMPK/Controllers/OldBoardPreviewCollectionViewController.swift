//
//  OldBoardPreviewCollectionViewController.swift
//  KMPK
//
//  Created by Karol Bukowski on 04.03.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit

class OldBoardPreviewCollectionViewController: NSObject {
    // MARK:- Private properties
    private let stationID: String
    private let provider: OldBoardItemsProviderProtocol
    private var dataSource = [BoardItem]()
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        
        return layout
    }()
    private(set) lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        
        collection.backgroundColor = .yellow
        
        collection.dataSource = self
        collection.delegate = self
        
        collection.register(UINib(nibName: String(describing: BoardPreviewCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: BoardPreviewCollectionViewCell.cellId)
        collection.register(BoardEmptyCollectionViewCell.self, forCellWithReuseIdentifier: BoardEmptyCollectionViewCell.cellId)
        
        return collection
    }()
    
    // MARK:- Initialization
    init(stationID: String, dataSource: OldBoardItemsProviderProtocol) {
        self.stationID = stationID
        self.provider = dataSource
        
        super.init()
        
        self.provider.boardItemsProvider { [weak self] (id) in
            if self?.stationID == id {
                DispatchQueue.main.async {
                    self?.reloadData()
                }
            }
        }
        
        reloadData() // reload with (provider) cache if available
    }
    
    // MARK:- Private methods
    private func reloadData() {
        let oldValues = self.dataSource
        let newValues = self.provider.boardItemsProvider(stationID: self.stationID)
        self.dataSource = newValues
        
        if oldValues.isEmpty || newValues.isEmpty {
            self.collectionView.reloadData()
        } else {
            self.collectionView.reloadData(with: BatchUpdates.compare(oldValues: oldValues, newValues: newValues))
        }
    }
    
    private func shouldUsePlaceholder() -> Bool {
        return self.provider.boardItemsProvider(stationID: self.stationID).isEmpty
    }
    
    private func numberOfItemsInSection(_ section: Int) -> Int {
        return shouldUsePlaceholder() ? 1 : self.dataSource.count
    }
    
    private func cellForItemAt(indexPath: IndexPath) -> UICollectionViewCell {
        return shouldUsePlaceholder() ? setupPlaceholderCell(indexPath: indexPath) : setupPreviewCell(indexPath: indexPath)
    }
    
    private func setupPreviewCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoardPreviewCollectionViewCell.cellId, for: indexPath) as? BoardPreviewCollectionViewCell else {
            fatalError("Could not dequeue cell \(String(describing: BoardPreviewCollectionViewCell.self))")
        }
        
        let board = self.dataSource[indexPath.row]
        
        cell.minutes = board.estimatedMinutes
        cell.line = "\(board.line) \(board.direction)"
        cell.isLive = !(board.poorGPS ?? true)
        
        return cell

    }
    
    private func setupPlaceholderCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoardEmptyCollectionViewCell.cellId, for: indexPath) as? BoardEmptyCollectionViewCell else {
            fatalError("Could not dequeue cell \(String(describing: BoardEmptyCollectionViewCell.self))")
        }
        
        return cell
    }
}

// MARK:- UICollectionViewDataSource
extension OldBoardPreviewCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return numberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return cellForItemAt(indexPath: indexPath)
    }
}

// MARK:- UICollectionViewDelegateFlowLayout
extension OldBoardPreviewCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - self.flowLayout.sectionInset.left - self.flowLayout.sectionInset.right - collectionView.contentInset.left - collectionView.contentInset.right - 10
        
        return CGSize(width: width, height: 30)
    }
}


