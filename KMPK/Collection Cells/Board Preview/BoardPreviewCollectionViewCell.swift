//
//  BoardPreviewCollectionViewCell.swift
//  KMPK
//
//  Created by Karol Bukowski on 04.03.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit

class BoardPreviewCollectionViewCell: UICollectionViewCell {
    static let cellId = "BoardPreviewCell"
    
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var lineLabel: UILabel!
    @IBOutlet private weak var liveLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var minutes: Int = 0 {
        didSet {
            self.timeLabel.text = String(describing: self.minutes)
        }
    }
    
    var line: String = "" {
        didSet {
            self.lineLabel.text = self.line
        }
    }
    
    var isLive: Bool = false {
        didSet {
            self.liveLabel.text = String(describing: self.isLive)
        }
    }

}
