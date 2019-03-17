//
//  MainFlowCoordinator.swift
//  Tasker
//
//  Created by andrey rulev on 17/03/2019.
//  Copyright © 2019 andrey rulev. All rights reserved.
//

import UIKit

class MainFlowCoordinator: ChildCoordinator {
    
    // MARK: - Private properties
    
    private let navigationController: UINavigationController
    
    // MARK: - Lifecycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.isNavigationBarHidden = true
    }
    
    func start() {
        let viewModel = TaskListViewModel()
        let controller = TaskListController(viewModel: viewModel)
        navigationController.setViewControllers([ controller ], animated: true)
    }
}

