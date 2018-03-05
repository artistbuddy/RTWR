//
//  BoardsViewController.swift
//  KMPK
//
//  Created by Karol Bukowski on 03.03.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit

protocol CollectionViewModelProtocol {
    var collection: UICollectionView { get }
}

class CollectionViewController: UIViewController {
    // MARK:- Private properties
    private let viewModel: CollectionViewModelProtocol
    private let collectionView: UICollectionView
    
    // MARK:- Initialization
    init(viewModel: CollectionViewModelProtocol) {
        self.viewModel = viewModel
        self.collectionView = viewModel.collection
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        collectionViewConstraints()
    }
    
    // MARK:- Private methods
    private func setupViews() {
        setupCollectionView()
        
        updateViewConstraints()
    }
    
    private func setupCollectionView() {
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.frame = self.view.bounds
        
        self.collectionView.alwaysBounceVertical = true
        
        self.view.addSubview(self.collectionView)
    }
    
    private func collectionViewConstraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}
