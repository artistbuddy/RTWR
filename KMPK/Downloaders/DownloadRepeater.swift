//
//  DownloadRepeater.swift
//  KMPK
//
//  Created by Karol Bukowski on 10.03.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

class DownloadRepeater {
    // MARK:- Private properties
    private let downloader: BoardItemsDownloadProtocol
    private var successCallback: APIQueryCallback<[BoardItem]>?
    private var failureCallback: APIFailureCallback?
    
    // MARK: Timer
    private lazy var queue = DispatchQueue(label: "com.kb.kmpk.downloadRepeater", attributes: .concurrent)
    private lazy var timer: DispatchSourceTimer = {
        let timer = DispatchSource.makeTimerSource(queue: queue)
        
        timer.schedule(deadline: .now(), repeating: .seconds(7), leeway: .seconds(1))
        timer.setEventHandler { //TODO weak self
            self.download()
        }
        
        return timer
    }()
    
    // MARK:- Initialization
    init(downloader: BoardItemsDownloadProtocol) {
        self.downloader = downloader
    }
    
    deinit {
        timer.cancel()
    }
    
    // MARK:- Private methods
    private func download() {
        guard let successCallback = self.successCallback else {
            return
        }
        
        self.download(success: successCallback, failure: self.failureCallback)
    }
}

// MARK:- BoardItemsDownloadProtocol
extension DownloadRepeater: BoardItemsDownloadProtocol {
    func download(success: @escaping APIQueryCallback<[BoardItem]>, failure: APIFailureCallback?) {
        self.successCallback = success
        self.failureCallback = failure
        
        self.timer.cancel()
        self.timer.resume()
    }
}
