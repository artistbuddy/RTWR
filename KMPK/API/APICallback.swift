//
//  APICallback.swift
//  KMPK
//
//  Created by Karol Bukowski on 28.01.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

typealias APIQueryCallback<T> = (_ result: T) -> Void
typealias APIFailureCallback = ((_ message: String) -> Void)

