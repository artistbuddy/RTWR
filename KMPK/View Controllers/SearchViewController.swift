//
//  ViewController.swift
//  KMPK
//
//  Created by Karol Bukowski on 28.01.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit

protocol SearchViewControllerDelegate: class {
    func searchViewController(didSelectStationID id: String)
    func searchViewController(didSelectStationName name: String)
}

class SearchViewController: UIViewController {
    // MARK:- IBOutlets
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var resultsCollectionView: UICollectionView!
    
    // MARK:- Public properties
    weak var delegate: SearchViewControllerDelegate?
    
    // MARK:- Private properties
    private var searchController: SearchController!
    private var resultsController: StationsCollectionViewController!
    
    private var needle = ""
    
    // MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()        
        setupView()
    }
    
    func setupView() {
        self.resultsController = StationsCollectionViewController(collectionView: self.resultsCollectionView)
        self.resultsController.delegate = self
        self.resultsController.dataSource = self
        
        self.searchController = SearchController(stationController: StationController(database: Session.shared.database))
        self.searchController.delegate = self.resultsController
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK:- Private methods
    private func didQuickSearch() -> Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: needle))
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.resultsCollectionView.contentInset.bottom = keyboardSize.height
        }
        
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        self.resultsCollectionView.contentInset.bottom = 0
    }
    
    // MARK:- IBActions
    @IBAction private func actionSearch(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }
        
        let needle = text.components(separatedBy: CharacterSet.alphanumerics.inverted).joined(separator: " ")
        
        self.needle = needle
        
        self.searchController.search(query: needle)
    }
}

// MARK:- StationsCollectionViewDelegate
extension SearchViewController: StationsCollectionViewDelegate {
    func stationsCollectionView(_ collectionView: UICollectionView, didSelect station: StationData) {
        
        if didQuickSearch() {
            self.delegate?.searchViewController(didSelectStationID: station.id)
        } else {
            self.delegate?.searchViewController(didSelectStationName: station.name)
        }
    }
}

// MARK:- StationsCollectionViewDataSource
extension SearchViewController: StationsCollectionViewDataSource {
    func highlightNeedle(_ collectionView: UICollectionView) -> String {
        return self.needle
    }
    
    func shouldUseCompactCell(_ collectionView: UICollectionView) -> Bool {
        return !didQuickSearch()
    }
}



