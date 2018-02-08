//
//  APIController.swift
//  KMPK
//
//  Created by Karol Bukowski on 28.01.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

class APIController {
    static let shared = APIController(auth: AuthController.shared)
    
    private let session = URLSession.shared
    private let jsonDecoder = JSONDecoder()
    private let auth: AuthController
    
    init(auth: AuthController) {
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
                Log.debug("APIController.exectue() Response is nil ")
            }
            
            if let data = data {
                do {
                    let result = try jsonDecoder.decode(Result.self, from: data)
                    success?(result)
                } catch let error {
                    failure?(String(describing: error))
                }
            }  else {
                Log.debug("APIController.exectue() Data is nil ")
            }
        }
        
        task.resume()
    }
}
