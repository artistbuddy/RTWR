//
//  APIProtocol.swift
//  KMPK
//
//  Created by Karol Bukowski on 09.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

protocol APIProtocol {
    func execute<Query: APIQuery, Result>(_ query: Query, success: APIQueryCallback<Result>?, failure: APIFailureCallback) where Result == Query.Result
    
    init(auth: APIAuth?)
}
