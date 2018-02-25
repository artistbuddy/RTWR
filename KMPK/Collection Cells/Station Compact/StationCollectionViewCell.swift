//
//  StationCompactCollectionViewCell.swift
//  KMPK
//
//  Created by Karol Bukowski on 24.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit

class StationCollectionViewCell: UICollectionViewCell {
    static let cellId = "StationCell"
    
    // MARK:- IBOutlets
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var idLabel: UILabel!
    
    // MARK:- Public properties
    var stationName: String = "" {
        didSet {
            self.nameLabel.attributedText = NSAttributedString(string: self.stationName.capitalized, attributes: TextAttributes.stationName.standard)
        }
    }
    
    var stationId: String = "" {
        didSet {
           self.idLabel.attributedText = NSAttributedString(string: self.stationId, attributes: TextAttributes.stationId.standard)
        }
    }
    
    var isCompact: Bool = false {
        didSet {
            self.idLabel.isHidden = self.isCompact
        }
    }
    
    // MARK:- Private properties
    private enum TextAttributes {
        case stationName
        case stationId
        
        var standard: [NSAttributedStringKey : Any] {
            switch self {
            case .stationName:
                return [NSAttributedStringKey.font : self.helveticaFont,
                        NSAttributedStringKey.foregroundColor : UIColor.black,
                        NSAttributedStringKey.paragraphStyle : self.leftParagraph]
            case .stationId:
                return [NSAttributedStringKey.font : self.menloFont,
                        NSAttributedStringKey.foregroundColor : UIColor.black,
                        NSAttributedStringKey.paragraphStyle : self.centerParagraph]
            }
        }
        
        var highlighted: [NSAttributedStringKey : Any] {
            switch self {
            case .stationName:
                return [NSAttributedStringKey.font : self.helveticaFont,
                        NSAttributedStringKey.backgroundColor : UIColor.yellow,
                        NSAttributedStringKey.paragraphStyle : self.leftParagraph]
            case .stationId:
                return [NSAttributedStringKey.font : self.menloFont,
                        NSAttributedStringKey.backgroundColor : UIColor.yellow,
                        NSAttributedStringKey.paragraphStyle : self.centerParagraph]
            }
        }
        
        // MARK: Helpers
        private var helveticaFont: UIFont {
            return UIFont(name: "HelveticaNeue", size: 17)!
        }
        
        private var menloFont: UIFont {
            return UIFont(name: "Menlo-Bold", size: 15)!
        }
        
        private var leftParagraph: NSParagraphStyle {
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .left
            return paragraph
        }
        
        private var centerParagraph: NSParagraphStyle {
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center
            return paragraph
        }
    }
    
    // MARK:- Public methods    
    func highlightNeedle(_ needle: String) {
        guard !needle.isEmpty else {
            return
        }
        
        let needles = needle.lowercased().components(separatedBy: " ")
        
        if isCompact {
            
            let ranges = needles.map{ self.stationName.lowercased().range(of: $0) }
            self.nameLabel.attributedText = highlightedString(self.stationName, in: ranges.flatMap{ $0 }, textAttributes: TextAttributes.stationName.highlighted)

        
        } else {
            
            let ranges = needles.map{ self.stationId.range(of: $0) }
            self.idLabel.attributedText = highlightedString(self.stationId, in: ranges.flatMap{ $0 }, textAttributes: TextAttributes.stationId.highlighted)            
        
        }
    }
    
    // MARK:- Private methods
    private func highlightedString(_ string: String, in ranges: [Range<String.Index>], textAttributes: [NSAttributedStringKey : Any]) -> NSAttributedString {
        
        let string = string.capitalized

        let output = NSMutableAttributedString(string: string)
        
        for range in ranges {
            output.addAttributes(textAttributes, range: NSRange(range, in: string))
        }
        
        return output
    }
    
    
}
