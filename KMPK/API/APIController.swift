//
//  APIController.swift
//  KMPK
//
//  Created by Karol Bukowski on 28.01.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation



class APIController: APIProtocol {
    static let shared = APIController(auth: nil)
    
    private var session: URLSession {
        return URLSession(configuration: URLSessionConfiguration.default, delegate: self.auth, delegateQueue: nil)
    }
    private let jsonDecoder = JSONDecoder()
    private let auth: APIAuth?
    
    required init(auth: APIAuth?) {
        self.auth = auth
    }
    
    func execute<Query: APIQuery, Result>(_ query: Query, success: APIQueryCallback<Result>?, failure: APIFailureCallback) where Result == Query.Result {
        
        let task = self.session.dataTask(with: query.urlRequest) { [jsonDecoder] (data, response, error) in
            
            if let error = error {
                failure?(error.localizedDescription)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                failure?(String(response.statusCode))
            } else {
                APILog.debug("APIController.exectue() Response is nil ")
            }
            
            if let data = data {
                do {
                    let result = try jsonDecoder.decode(Result.self, from: data)
                    success?(result)
                } catch let error {
                    failure?(String(describing: error))
                }
            }  else {
                APILog.debug("APIController.exectue() Data is nil ")
            }
        }
        
        task.resume()
    }
}
