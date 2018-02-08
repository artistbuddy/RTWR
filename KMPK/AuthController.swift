//
//  AuthController.swift
//  KMPK
//
//  Created by Karol Bukowski on 08.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

class AuthController: NSObject, URLSessionDelegate {
    static let shared = AuthController()
    
    private override init() {
        super.init()
    }
}
