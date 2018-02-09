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
    
    func execute<Query: APIJSONQuery, Result>(_ query: Query, successJSON: @escaping APIQueryCallback<Result>, failure: APIFailureCallback?) where Result == Query.Result {
        
        execute(query, success: { [jsonDecoder] (data) in
            do {
                let result = try jsonDecoder.decode(Result.self, from: data as! Data)
                successJSON(result)
            } catch let error {
                // Serialization error
                failure?(String(describing: error))
            }
        }, failure: failure)

    }
    
    func execute(_ query: APIQuery, success: @escaping APIQueryCallback<Data>, failure: APIFailureCallback?) {
        
        let task = self.session.dataTask(with: query.urlRequest) { (data, response, error) in
            
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
                success(data)
            }  else {
                APILog.debug("APIController.exectue() Data is nil ")
            }
        }
        
        task.resume()
    }
}
