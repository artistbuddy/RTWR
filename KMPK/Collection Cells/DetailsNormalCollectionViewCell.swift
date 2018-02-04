//
//  DetailsNormalCollectionViewCell.swift
//  KMPK
//
//  Created by Karol Bukowski on 04.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit

class DetailsNormalCollectionViewCell: UICollectionViewCell {
    static let cellID = "detailsNormalCell"
    
    var cellWidth: CGFloat = 0.0 {
        didSet {
            self.contentView.widthAnchor.constraint(equalToConstant: self.cellWidth).isActive = true
        }
    }
    
    @IBOutlet weak var estimatedMinutesLabel: UILabel!
    @IBOutlet weak var lineLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var lastStopLabel: UILabel!
    @IBOutlet weak var airConditioningLabel: UILabel!
    @IBOutlet weak var disabledFacilitiesLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
