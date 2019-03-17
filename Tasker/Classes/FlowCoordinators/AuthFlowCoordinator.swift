//
//  AuthFlowCoordinator.swift
//  Tasker
//
//  Created by andrey rulev on 17/03/2019.
//  Copyright © 2019 andrey rulev. All rights reserved.
//

import Foundation
import UIKit

class AuthFlowCoordinator: ChildCoordinator {
    
    // MARK: - Private properties
    
    private let navigationController: UINavigationController
    
    // MARK: - Lifecycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = LoginViewModel()
        let controller = LoginController(viewModel: viewModel)
        
        controller.registrationButtonPressed = { [weak self] in
            let registrationViewModel = RegistrationViewModel()
            let registrationController = RegistrationController(viewModel: registrationViewModel)
            
            self?.navigationController.pushViewController(registrationController, animated: true)
        }
        
        navigationController.setViewControllers([ controller ], animated: true)
    }
}
