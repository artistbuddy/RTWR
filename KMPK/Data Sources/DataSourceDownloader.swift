//
//  DataSourceDownloader.swift
//  KMPK
//
//  Created by Karol Bukowski on 12.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

protocol DataSourceDownloader {
    associatedtype Data
    
    func download(success: @escaping APIQueryCallback<Data>, failure: APIFailureCallback?)
}
