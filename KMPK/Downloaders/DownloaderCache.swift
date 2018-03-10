//
//  DownloaderCache.swift
//  KMPK
//
//  Created by Karol Bukowski on 10.03.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

class DownloaderCache {
    // MARK:- Private properties
    private let downloader: BoardItemsDownloadProtocol
    private var cache: [BoardItem]?
    
    // MARK:- Initialization
    init(downloader: BoardItemsDownloadProtocol) {
        self.downloader = downloader
    }
}

// MARK:- BoardItemsDownloadProtocol
extension DownloaderCache: BoardItemsDownloadProtocol {
    func download(success: @escaping APIQueryCallback<[BoardItem]>, failure: APIFailureCallback?) {
        
        if let items = self.cache {
            success(items)
        }
        
        self.downloader.download(success: { (result) in
            self.cache = result
            success(result)
        }) { (reason) in
            failure?(reason)
        }
    }
}
