//
//  Query.swift
//  KMPK
//
//  Created by Karol Bukowski on 28.01.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

protocol APIQuery {
    associatedtype Result: Decodable
    
    var path: String { get }
    var parameters: [String: String]? { get }
    var router: APIRouter { get }
}

extension APIQuery {
    private static var httpMethod: APIMethod {
        return APIMethod.get
    }
    
    private var url: URL {
        var components = URLComponents(url: self.router.baseURL, resolvingAgainstBaseURL: true)!
        
        components.path = self.path
        
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
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: self.url)
        
        request.httpMethod = Self.httpMethod.rawValue
        
        return request
    }
}
