//
//  DataSourcePolicyController.swift
//  KMPK
//
//  Created by Karol Bukowski on 12.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

/*
enum PolicyType {
    case openSource //free
    case comercial //consent required
    case unofficial //consent unknown
    case official //approved
}
*/
 
enum DownloaderPolicy {
    case strict //open source and official
    case mixed //strict + unofficial
    case any
}

protocol DownloaderPolicyProtocol {
    func getPolicy<T>(downloader: T.Type) -> DownloaderPolicy
}

final class DownloaderPolicyController: DownloaderPolicyProtocol {
    static let global: DownloaderPolicyProtocol = DownloaderPolicyController()
    
    let defaultPolicy: DownloaderPolicy = .strict
    
    private init() { }
    
    func getPolicy<T>(downloader: T.Type) -> DownloaderPolicy {
        switch downloader {
        case is BoardItemsDownloader.Type: return .mixed
        case is StationsDownloader.Type: return .mixed
        default:
            return self.defaultPolicy
        }
    }
}
