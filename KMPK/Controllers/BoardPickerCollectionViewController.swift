//
//  BoardPickerCollectionViewController.swift
//  KMPK
//
//  Created by Karol Bukowski on 03.03.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit

class BoardPickerCollectionViewController: NSObject {
    // MARK:- Private properties
    private let provider: BoardItemsProviderProtocol
    private let controller: StationControllerProtocol
    private let stationName: String
    private lazy var dataSource = [StationData]()
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        
        return layout
    }()
    private(set) lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        
        collection.backgroundColor = UIColor.blue
        
        collection.dataSource = self
        collection.delegate = self
        
        collection.register(BoardPickerCollectionViewCell.self, forCellWithReuseIdentifier: BoardPickerCollectionViewCell.cellId)
        
        return collection
    }()
    
    // MARK:- Initialization
    init(stationName: String, stationController: StationControllerProtocol, dataSource: BoardItemsProviderProtocol) {
        self.stationName = stationName
        self.controller = stationController
        self.provider = dataSource
        
        super.init()
        
        setupDataSource()
    }
    
    // MARK:- Private methods
    private func setupDataSource() {
        self.dataSource = self.controller.get(name: self.stationName)

        collectionView.reloadData()
    }
}

// MARK:- UICollectionViewDataSource
extension BoardPickerCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoardPickerCollectionViewCell.cellId, for: indexPath) as? BoardPickerCollectionViewCell else {
            fatalError("Could not dequeue cell \(String(describing: BoardPickerCollectionViewCell.self))")
        }

        let data = self.dataSource[indexPath.row]
        
        cell.controller = BoardPreviewCollectionViewController(stationID: data.id, dataSource: self.provider)
        cell.title = data.name + data.id
        
        return cell
    }
}

// MARK:- UICollectionViewDelegateFlowLayout
extension BoardPickerCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - self.flowLayout.sectionInset.left - self.flowLayout.sectionInset.right - collectionView.contentInset.left - collectionView.contentInset.right - 10
        
        return CGSize(width: width, height: 150)
    }
}
