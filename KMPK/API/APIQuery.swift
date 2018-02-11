//
//  APIRawQuery.swift
//  KMPK
//
//  Created by Karol Bukowski on 09.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

protocol APIQuery {
    var path: String { get }
    var parameters: [String: String]? { get }
    var router: APIRouter { get }
    var method: APIMethod { get }
}

extension APIQuery {
    private var url: URL {
        var components = URLComponents(url: self.router.baseURL, resolvingAgainstBaseURL: true)!
        
        components.path = components.path + self.path
        
        if let parameters = self.parameters {
            components.queryItems = []
            
            for (name, value) in parameters {
                let item = URLQueryItem(name: name, value: value)
                components.queryItems!.append(item)
            }
        }
        
        guard let url = components.url else {
            fatalError("APIQuery invalid URL")
        }
        
        return url
    }
    
    var method: APIMethod {
        return APIMethod.get
    }
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: self.url)
        
        request.httpMethod = self.method.rawValue
        
        return request
    }
}
