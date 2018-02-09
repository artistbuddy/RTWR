//
//  APICredential.swift
//  KMPK
//
//  Created by Karol Bukowski on 09.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

protocol APICredential {
    func credential(for protectionSpace: URLProtectionSpace) -> URLCredential?
}
