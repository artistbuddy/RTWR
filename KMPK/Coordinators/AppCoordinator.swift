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
        let controller = UINavigationController()
        controller.isNavigationBarHidden = false
        
        // TODO: extract navigationBar
        var statusBarHeight: CGFloat = 0
        if UIApplication.shared.statusBarOrientation.isPortrait {
            statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.size.width
        }
        
        var navigationBarHeight = controller.navigationBar.frame.height
        
        var frame = controller.view.bounds
        frame.origin.x = 0
        frame.origin.y = -statusBarHeight
        frame.size.height = navigationBarHeight + statusBarHeight
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.frame = frame
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        controller.navigationBar.isTranslucent = true
        controller.navigationBar.backgroundColor = UIColor.clear
        controller.navigationBar.insertSubview(blurView, at: 0)
    
        return controller
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
    
//    let provider = BoardDataProvider()
//    lazy var picker = {
//        return OldBoardPickerCollectionViewController(stationIDs: ["29311", "10226"], stationController: StationController(database: Session.shared.database), dataSource: self.provider)
//    }()
    
    // MARK:- Scenes
    private func showBoardPickerScene(stationName name: String) {
        let s = StationsController(database: Session.shared.database)
        let c = BoardPickerCollectionController(stationName: name, stationsController: s)
        let vm = BoardPickerViewModel(controller: c)
        let vc = CollectionViewController(viewModel: vm)
        
        self.navigationController.pushViewController(vc, animated: true)
    }
    
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
        showBoardPickerScene(stationName: name)
    }
}
