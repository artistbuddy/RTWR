//
//  UpdateViewController.swift
//  KMPK
//
//  Created by Karol Bukowski on 16.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit

class UpdateViewController: UIViewController, UpdateControllerDelegate {
    func updateControllerDidFinish() {
        performSegue(withIdentifier: "main", sender: nil)
    }
    
    var controller: UpdateController {
        let c = UpdateController()
        c.delegate = self
        
        return c
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if controller.updateNeeded() {
            controller.update()
        } else {
            performSegue(withIdentifier: "main", sender: nil)
        }
        
    }

}
