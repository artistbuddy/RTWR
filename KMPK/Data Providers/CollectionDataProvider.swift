//
//  CollectionDataProvider.swift
//  KMPK
//
//  Created by Karol Bukowski on 11.03.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

protocol CollectionDataProvider: class {
    associatedtype Data
    
    func numberOfItems() -> Int
    func numberOfItems(inSection section: Int) -> Int
    func numberOfSections() -> Int
    
    func itemAt(indexPath: IndexPath) -> Data
}
