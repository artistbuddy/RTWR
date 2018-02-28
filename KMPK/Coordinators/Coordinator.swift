//
//  Coordinator.swift
//  KMPK
//
//  Created by Karol Bukowski on 28.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
}

extension Coordinator {
    func addChildCoordinator(_ childCoordinator: Coordinator) {
        self.childCoordinators.append(childCoordinator)
    }
    
    func removeChildCoordinator(_ childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== childCoordinator }
    }
}
