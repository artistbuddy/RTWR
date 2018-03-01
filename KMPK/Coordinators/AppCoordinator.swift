//
//  AppCoordinator.swift
//  KMPK
//
//  Created by Karol Bukowski on 28.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import UIKit

class AppCoordinator: RootViewCoordinator {
    // MARK:- Public properties
    var childCoordinators: [Coordinator] = []
    var rootViewController: UIViewController {
        return self.navigationController
    }
    
    // MARK:- Private properties
    private let window: UIWindow
    private lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        
        return navigationController
    }()
    
    // MARK:- Initializers
    init(window: UIWindow) {
        self.window = window
        
        self.window.rootViewController = self.rootViewController
        self.window.makeKeyAndVisible()
    }

    func start() {
        showUpdateScene()
    }
    
    // MARK:- Scenes
    private func showUpdateScene() {
        let update = UpdateController()
        
        guard update.updateNeeded() else {
            showSearchScene()
            return
        }
        
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UpdateViewController") as? UpdateViewController else {
            fatalError("Could't instantiate UpdateViewController")
        }
        
        vc.delegate = self
        
        update.delegate = vc
        update.update()
        
        self.navigationController.setViewControllers([vc], animated: true)
    }
    
    private func showSearchScene() {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else {
            fatalError("Could't instantiate SearchViewController")
        }
        
        vc.delegate = self
        
        self.navigationController.setViewControllers([vc], animated: true)
    }
}

// MARK:- UpdateViewControllerDelegate
extension AppCoordinator: UpdateViewControllerDelegate {
    func updateViewControllerDidFinish() {
        showSearchScene()
    }
}

// MARK:- SearchViewControllerDelegate
extension AppCoordinator: SearchViewControllerDelegate {
    func searchViewController(didSelectStationID id: String) {
        // TODO: implement searchViewController(didSelectStationID:)
    }
    
    func searchViewController(didSelectStationName name: String) {
        // TODO: implement searchViewController(didSelectStationName:)
    }
}
