//
//  AppFlowCoordinator.swift
//  Tasker
//
//  Created by andrey rulev on 17/03/2019.
//  Copyright © 2019 andrey rulev. All rights reserved.
//

import UIKit

protocol ChildCoordinator {
    func start()
}

class AppFlowCoordinator {
    
    // MARK: - Private properties
    
    private let window: UIWindow
    private let rootNavigationController: UINavigationController
    private let keychainStorage = KeychainStorage()
    private var childCoordinator: ChildCoordinator?
    
    // MARK: - Lifecycle
    
    init(window: UIWindow) {
        self.window = window
        self.rootNavigationController = UINavigationController()
    }
    
    func start() {
        Config.configureFlex()
        window.rootViewController = rootNavigationController
        setChildCoordinator(makeLaunchingCoordinator())
        window.makeKeyAndVisible()
    }
    
    func login() {
        let coordinator = MainFlowCoordinator(navigationController: rootNavigationController)
        setChildCoordinator(coordinator)
    }
}

// MARK: - Child coordinators

private extension AppFlowCoordinator {
    func makeLaunchingCoordinator() -> ChildCoordinator {
        if keychainStorage.tokenId() != nil {
            return MainFlowCoordinator(navigationController: rootNavigationController)
        } else {
            return AuthFlowCoordinator(navigationController: rootNavigationController)
        }
    }
    
    func setChildCoordinator(_ coordinator: ChildCoordinator) {
        childCoordinator = coordinator
        coordinator.start()
    }
}
