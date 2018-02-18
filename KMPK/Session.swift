//
//  Session.swift
//  KMPK
//
//  Created by Karol Bukowski on 09.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

class Session {
    static let shared = Session()
    
    let api: APIProtocol = APIController(auth: APIAuth(credential: APIConfig.impk))
    let database: DatabaseAccess = DatabaseController()
    
    private init() {
        
    }
}
