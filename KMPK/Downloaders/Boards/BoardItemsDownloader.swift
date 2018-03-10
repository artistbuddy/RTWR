//
//  BoardItemsDownloader.swift
//  KMPK
//
//  Created by Karol Bukowski on 20.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

protocol BoardItemsDownloadProtocol {
    func download(success: @escaping APIQueryCallback<[BoardItem]>, failure: APIFailureCallback?)
}

class BoardItemsDownloader {
    // MARK:- Private properties
    private var stationID: String?
    private var api: APIProtocol = Session.shared.api
    private var continouesDownload: Bool = false
    private var useCache: Bool = true
    
    private let policy: DownloaderPolicy
    
    // MARK:- Initialization
    init(policy: DownloaderPolicy) {
        self.policy = policy
    }
    
    convenience init() {
        self.init(policy: DownloaderPolicyController.global.getPolicy(downloader: type(of: self)))
    }
    
    // MARK:- Public methods
    func stationID(_ id: String) -> BoardItemsDownloader {
        self.stationID = id
        
        return self
    }
    
    func setAPI(_ api: APIProtocol) -> BoardItemsDownloader {
        self.api = api
        
        return self
    }
    
    func continouesDownload(_ continoues: Bool) -> BoardItemsDownloader {
        self.continouesDownload = continoues
        
        return self
    }
    
    func useCache(_ cache: Bool) -> BoardItemsDownloader {
        self.useCache = cache
        
        return self
    }
    
    func build() throws -> BoardItemsDownloadProtocol {
        guard let id = self.stationID else {
            throw BoardItemsDownloaderError.invalidStationID
        }
        
        var downloader: BoardItemsDownloadProtocol!
        
        switch self.policy {
        case .mixed:
            downloader = TBoardItemsDownload(stationID: id, api: self.api)
        default:
            fatalError("Policy \(self.policy) not implemented")
        }
        
        if self.useCache {
            downloader = DownloaderCache(downloader: downloader)
        }
        
        if self.continouesDownload {
            downloader = DownloadRepeater(downloader: downloader)
        }
        
        return downloader
    }
}

// MARK:- Error
extension BoardItemsDownloader {
    enum BoardItemsDownloaderError: Error {
        case invalidStationID
        case invalidAPI
    }
}

