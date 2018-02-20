//
//  DataSourcePolicyController.swift
//  KMPK
//
//  Created by Karol Bukowski on 12.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

/*
enum DataSourceType {
    case openSource //free
    case comercial //consent required
    case unofficial //consent unknown
    case official //approved
}
*/
 
enum DataSourcePolicy {
    case strict //open source and official
    case mixed //strict + unofficial
    case any
}

final class DataSourcePolicyController {
    static let global = DataSourcePolicyController()
    
    let defaultPolicy: DataSourcePolicy = .strict
    
    private init() { }
    
    func getPolicy<T>(dataSource: T.Type) -> DataSourcePolicy {
        switch dataSource {
        case is StationDataSource.Type: return .mixed
        case is BoardDataSource.Type: return .mixed
        default:
            return self.defaultPolicy
        }
    }
}
