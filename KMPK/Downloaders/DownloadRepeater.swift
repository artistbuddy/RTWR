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
    private var timer: DispatchSourceTimer?
    
    // MARK:- Initialization
    init(downloader: BoardItemsDownloadProtocol) {
        self.downloader = downloader
    }
    
    deinit {
        APILog.debug("DownloadRepeater deinit")
        stopTimer()
    }
    
    // MARK:- Private methods
    private func startTimer() {
        self.timer = DispatchSource.makeTimerSource(queue: self.queue)
        
        self.timer?.schedule(deadline: .now(), repeating: .seconds(7), leeway: .seconds(1))
        self.timer?.setEventHandler { [weak self] in
            self?.download()
        }
        
        self.timer?.resume()
    }
    
    private func stopTimer() {
        self.timer?.cancel()
        self.timer = nil
    }
    
    private func download() {
        guard let successCallback = self.successCallback else {
            return
        }
        
        self.downloader.download(success: successCallback, failure: failureCallback)
    }
}

// MARK:- BoardItemsDownloadProtocol
extension DownloadRepeater: BoardItemsDownloadProtocol {
    func download(success: @escaping APIQueryCallback<[BoardItem]>, failure: APIFailureCallback?) {
        self.successCallback = success
        self.failureCallback = failure
        
        startTimer()
    }
}
