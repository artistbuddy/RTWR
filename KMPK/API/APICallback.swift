//
//  APICallback.swift
//  KMPK
//
//  Created by Karol Bukowski on 28.01.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

typealias APIQueryCallback<T> = (_ result: T) -> Void
typealias APIFailureCallback = (_ reason: APIFailure) -> Void

enum APIFailure: LocalizedError {
    case serializationError
    case invalidData
    case serverError(code: Int)
    case otherError(description: String, userInfo: [String : Any]?)

    var errorDescription: String? {
        switch self {
        case .serializationError: return "Serialization error"
        case .invalidData: return "Invalid data"
        case .serverError(_): return "Server error"
        case .otherError(_, _): return "Unknown error"
        }
    }
    
    var failureReason: String? {
        switch self {
        case .serializationError: return "Recieved data is corrupted"
        case .invalidData: return "Data type unsupported"
        case .serverError(let code): return "HTTP response code: \(code)"
        case .otherError(let description, _): return description
        }
    }

}
