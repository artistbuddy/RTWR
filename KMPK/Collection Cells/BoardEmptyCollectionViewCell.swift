//
//  BoardEmptyCollectionViewCell.swift
//  KMPK
//
//  Created by Karol Bukowski on 04.03.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit

class BoardEmptyCollectionViewCell: UICollectionViewCell {
    // MARK:- Public properties
    static let cellId = "BoardEmptyCell"
    
    // MARK:- Private properties
    private let queue = DispatchQueue(label: "com.kb.kmpk.emptyCell", attributes: .concurrent)
    private lazy var timer: DispatchSourceTimer = {
        let timer = DispatchSource.makeTimerSource(queue: queue)
        
        timer.schedule(deadline: .now(), repeating: .seconds(5), leeway: .seconds(1))
        timer.setEventHandler {
            DispatchQueue.main.async {
                if self.label.isHidden {
                    self.label.isHidden = false
                    self.busyIndicator.stopAnimating()
                } else {
                    self.label.isHidden = true
                    self.busyIndicator.startAnimating()
                }
            }
        }
        
        return timer
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel(frame: self.frame)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Not found any vehicles in the nearby area :("
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isHidden = false
        
        return label
    }()
    
    private lazy var busyIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: self.frame)
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.activityIndicatorViewStyle = .gray
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
    // MARK:- Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        
        //self.timer.resume()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        //self.timer.cancel()
    }
    
    // MARK:- Life cycle
    override func updateConstraints() {
        super.updateConstraints()
        
        labelConstraints()
        busyIndicatorConstraints()
    }
    
    // MARK:- Private methods
    private func setupView() {        
        self.contentView.addSubview(self.label)
        self.contentView.addSubview(self.busyIndicator)
        
        self.contentView.updateConstraints()
    }
    
    private func labelConstraints() {
        let safeArea = self.contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.label.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.label.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.label.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.label.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func busyIndicatorConstraints() {
        let safeArea = self.contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.busyIndicator.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.busyIndicator.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.busyIndicator.widthAnchor.constraint(equalToConstant: 20.0),
            self.busyIndicator.heightAnchor.constraint(equalToConstant: 20.0)
        ])
    }
}
