//
//  StationDataSource.swift
//  KMPK
//
//  Created by Karol Bukowski on 12.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

protocol StationDataSourceDelegate {
    func stationDataSource(didDownload: [StationData])
}

class StationDataSource: DataSourceDownloader {
    var delegate: StationDataSourceDelegate?
    
    let policy: DataSourcePolicy
    let api: APIProtocol
    
    init(api: APIProtocol, policy: DataSourcePolicy = DataSourcePolicyController.global.defaultPolicy) {
        self.api = api
        self.policy = policy
    }
    
    func download(callback: DataSourceCallback?) {
        switch policy {
        case .strict:
            callback?(false, nil)
        case .mixed:
            callback?(false, nil)
        case .any:
            callback?(false, nil)
        }
    }

}
