//
//  BoardPickerCollectionViewCell.swift
//  KMPK
//
//  Created by Karol Bukowski on 03.03.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit

class BoardPickerCollectionViewCell: UICollectionViewCell {
    static let cellId = "BoardPickerCell"
    
    // MARK:- Private properties
    private let label: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = " "

        return label
    }()
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
 
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = UIColor.green
        
        collection.register(UINib(nibName: String(describing: BoardPreviewCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: BoardPreviewCollectionViewCell.cellId)
        collection.register(BoardEmptyCollectionViewCell.self, forCellWithReuseIdentifier: BoardEmptyCollectionViewCell.cellId)
        
        return collection
    }()

    // MARK:- Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Life cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
//        self.dataSource = nil
//        self.delegate = nil
//        self.layout = nil
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        labelConstraints()
        collectionViewConstraints()
    }
    
    // MARK:- Public properties
    var dataSource: UICollectionViewDataSource? {
        didSet {
            self.collectionView.dataSource = self.dataSource
            self.collectionView.reloadData()
        }
    }
    
    var delegate: UICollectionViewDelegate? {
        didSet {
            self.collectionView.delegate = self.delegate
        }
    }
    
    var layout: UICollectionViewLayout? {
        didSet {
            guard let layout = self.layout else {
                return
            }
            
            self.collectionView.setCollectionViewLayout(layout, animated: true)
        }
    }
    
    var title: String = "" {
        didSet {
            self.label.text = self.title
        }
    }
    
    // MARK:- Private methods
    private func setupView() {
        self.contentView.backgroundColor = .red
        
        self.contentView.addSubview(self.label)
        self.contentView.addSubview(self.collectionView)
        
        updateConstraints()
    }
    
    private func labelConstraints() {
        let safeArea = self.contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.label.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.label.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.label.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func collectionViewConstraints() {
        let safeArea = self.contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.label.bottomAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor)
        ])
    }
}

// MARK:- BoardItemsDataProviderDelegate
extension BoardPickerCollectionViewCell: BoardItemsDataProviderDelegate {
    func boardItemsDataProvider(didUpdate batchUpdates: BatchUpdates) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
