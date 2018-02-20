//
//  DetailsViewController.swift
//  KMPK
//
//  Created by Karol Bukowski on 03.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var detailsCollectionView: UICollectionView!
    
    private(set) var detailsController: DetailsCollectionViewController!
    private(set) var stationController: OldStationController!
    private var timer: DispatchSourceTimer?
    
    var id: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    func setupView() {
        self.detailsController = DetailsCollectionViewController(collectionView: self.detailsCollectionView)
        self.stationController = OldStationController()
        self.stationController.delegate = self.detailsController
        
        self.timer?.cancel()
        self.timer = DispatchSource.makeTimerSource(queue: DispatchQueue(label: "timer", attributes: .concurrent))
        self.timer?.schedule(deadline: .now(), repeating: .seconds(5), leeway: .seconds(1))
        self.timer?.setEventHandler(handler: { [weak self] in
            self?.stationController.show(id: self!.id)
        })
        self.timer?.resume()
        
        self.stationController.show(id: self.id)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.detailsCollectionView.contentInset.bottom = keyboardSize.height
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.detailsCollectionView.contentInset.bottom = 0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.timer?.cancel()
        self.timer = nil
    }
}
