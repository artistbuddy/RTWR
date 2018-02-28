//
//  UpdateViewController.swift
//  KMPK
//
//  Created by Karol Bukowski on 16.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit

protocol UpdateViewControllerDelegate: class {
    func updateViewControllerDidFinish()
}

class UpdateViewController: UIViewController {
    // MARK:- Public properties
    weak var delegate: UpdateViewControllerDelegate?
}

// MARK:- UpdateControllerDelegate
extension UpdateViewController: UpdateControllerDelegate {
    // TODO: implement updateController(progress:)
    func updateController(progress: Int) {
        
    }
    
    func updateControllerDidFinish() {
        self.delegate?.updateViewControllerDidFinish()
    }
}
