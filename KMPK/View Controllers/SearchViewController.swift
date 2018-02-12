//
//  ViewController.swift
//  KMPK
//
//  Created by Karol Bukowski on 28.01.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var resultsCollectionView: UICollectionView!
    
    private(set) var searchController: SearchController!
    private(set) var resultsController: ResultsCollectionViewController!
    
    private var selectedResult: SearchResultData?
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        setupView()
    }
    
    func setupView() {
        self.resultsController = ResultsCollectionViewController(collectionView: self.resultsCollectionView)
        self.resultsController.delegate = self
        
        self.searchController = SearchController()
        self.searchController.delegate = self.resultsController
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.resultsCollectionView.contentInset.bottom = keyboardSize.height
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.resultsCollectionView.contentInset.bottom = 0
    }
    
    @IBAction func actionSearch(_ sender: UITextField) {
        guard let text = sender.text, text.count > 2 else {
            return
        }
        
        self.searchController.search(query: text)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.searchTextField.resignFirstResponder()
        
        if let destination = segue.destination as? DetailsViewController, segue.identifier == "details" {
            destination.id = self.selectedResult?.id
            destination.title = self.selectedResult?.name
        }
    }
}

// MARK:- ResultsCollectionViewControllerDelegate
extension SearchViewController: ResultsCollectionViewControllerDelegate {
    func resultsCollectionViewController(_ controller: ResultsCollectionViewController, didSelectResult result: SearchResultData) {
        self.selectedResult = result
        performSegue(withIdentifier: "details", sender: nil)
    }
    
    
    
    
}

