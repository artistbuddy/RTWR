//
//  APIProtocol.swift
//  KMPK
//
//  Created by Karol Bukowski on 09.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

protocol APIProtocol {
    func execute<Query: APIJSONQuery, Result>(_ query: Query, successJSON: @escaping APIQueryCallback<Result>, failure: APIFailureCallback?) where Result == Query.Result
    
    func execute(_ query: APIQuery, success: @escaping APIQueryCallback<Data>, failure: APIFailureCallback?)
    
    init(auth: APIAuth?)
}
