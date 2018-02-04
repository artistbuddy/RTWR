//
//  Log.swift
//  KMPK
//
//  Created by Karol Bukowski on 28.01.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

public class Log {
    public static func debug(_ items: Any...) {
        #if DEBUG
            print(items)            
        #endif
        
    }
}
