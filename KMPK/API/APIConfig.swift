//
//  APIRouter.swift
//  KMPK
//
//  Created by Karol Bukowski on 28.01.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

enum APIConfig: APIRouter, APICredential {
    case tram
    case impk
    
    var baseURL: URL {
        switch self {
        case .tram:
            return URL(string: "http://tram.wroclaw.pl")!
        case .impk:
            return URL(string: "https://62.233.178.84:8088")!
        }
    }
    
    func credential(for protectionSpace: URLProtectionSpace) -> URLCredential? {
        let realm = protectionSpace.realm

        switch realm {
        case .some("MPK Realm"):
            return URLCredential(user: Credentials.user, password: Credentials.password, persistence: .forSession)
        default:
            return nil
        }
    }
}
