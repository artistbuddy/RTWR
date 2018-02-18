//
//  UpdateViewController.swift
//  KMPK
//
//  Created by Karol Bukowski on 16.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit

class UpdateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        StationImporter(database: Session.shared.database, dataSource: StationDataSource(api: Session.shared.api, policy: .mixed)).importData { (error) in
            if let error = error {
                print("Error importing")
            } else {
                self.performSegue(withIdentifier: "main", sender: nil)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
