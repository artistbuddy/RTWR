//
//  SearchResultCollectionViewCell.swift
//  KMPK
//
//  Created by Karol Bukowski on 04.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit

class SearchResultCollectionViewCell: UICollectionViewCell {
    static let cellID = "searchResultCell"
    
    var cellWidth: CGFloat = 0.0 {
        didSet {
            self.contentView.widthAnchor.constraint(equalToConstant: self.cellWidth).isActive = true
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var routesLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
