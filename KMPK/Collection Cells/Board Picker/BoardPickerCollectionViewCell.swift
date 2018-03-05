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
    private lazy var label: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1

        return label
    }()
    
    private var collectionView: UICollectionView?

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
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        labelConstraints()
        collectionViewConstraints()
    }
    
    // MARK:- Public properties
    var controller: BoardPreviewCollectionViewController? {
        didSet {
            addCollectionView()
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
        
        updateConstraints()
    }
    
    private func addCollectionView() {
        guard let view = self.controller?.collectionView else {
            return
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView = view
        self.contentView.addSubview(view)
        updateConstraints()
    }
    
    private func labelConstraints() {
        let safeArea = self.contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.label.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.label.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.label.widthAnchor.constraint(equalTo: safeArea.widthAnchor)
            ])
    }
    
    private func collectionViewConstraints() {
        guard let collection = self.collectionView else {
            return
        }
        
        let safeArea = self.contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: self.label.bottomAnchor),
            collection.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            collection.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collection.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor)
        ])
    }
}
