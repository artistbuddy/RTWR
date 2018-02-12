//
//  DataSourceDownloader.swift
//  KMPK
//
//  Created by Karol Bukowski on 12.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

typealias DataSourceCallback = (_ success: Bool, _ message: String?) -> Void

protocol DataSourceDownloader {
    func download(callback: DataSourceCallback?)
}
