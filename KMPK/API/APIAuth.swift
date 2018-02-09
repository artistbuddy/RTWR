//
//  APIAuth.swift
//  KMPK
//
//  Created by Karol Bukowski on 09.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

class APIAuth: NSObject, URLSessionTaskDelegate {
    let credential: APICredential
    
    init(credential: APICredential) {
        self.credential = credential
    }
    
    // MARK:- URLSessionTaskDelegate
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        let space = challenge.protectionSpace
        let method = space.authenticationMethod

        if method == NSURLAuthenticationMethodServerTrust {
            // FIXME: implement NSURLAuthenticationMethodServerTrust
            if let trust = space.serverTrust {
                completionHandler(.useCredential, URLCredential(trust: trust))
            }
        } else {
            let credential = self.credential.credential(for: space)
            completionHandler(.useCredential, credential)
        }
    }
    
}
