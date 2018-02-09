//
//  Query.swift
//  KMPK
//
//  Created by Karol Bukowski on 28.01.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

protocol APIJSONQuery: APIQuery {
    associatedtype Result: Decodable
}

extension APIJSONQuery {
    var method: APIMethod {
        return APIMethod.get
    }
}