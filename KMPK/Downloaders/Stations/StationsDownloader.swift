//
//  StationDataSource.swift
//  KMPK
//
//  Created by Karol Bukowski on 12.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

protocol StationsDownloadProtocol {
    func download(success: @escaping APIQueryCallback<[StationData]>, failure: APIFailureCallback?)
}

class StationsDownloader {
    // MARK:- Private properties
    private var api: APIProtocol = Session.shared.api
    
    private let policy: DownloaderPolicy
    
    // MARK:- Initialization
    init(policy: DownloaderPolicy) {
        self.policy = policy
    }
    
    convenience init() {
        self.init(policy: DownloaderPolicyController.global.getPolicy(downloader: type(of: self)))
    }
    
    // MARK:- Public methods
    func setAPI(_ api: APIProtocol) -> StationsDownloader {
        self.api = api
        
        return self
    }
    
    func build() throws -> StationsDownloadProtocol {
        switch self.policy {
        case .mixed:
            return OPTStationsDownload(api: self.api)
        default:
            fatalError("Policy \(self.policy) not implemented")
        }
    }
}

// MARK:- Error
extension StationsDownloader {
    enum StationsDownloaderError: Error {
        case invalidAPI
    }
}



