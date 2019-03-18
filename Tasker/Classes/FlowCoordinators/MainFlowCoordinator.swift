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
    }
    
    func start() {
        let viewModel = TaskListViewModel()
        let controller = TaskListController(viewModel: viewModel)
        
        controller.createNewTaskButonPressed = { [weak self] in
            let createTaskViewModel = CreateTaskViewModel(createTaskState: .new, taskItem: nil)
            let createTaskController = CreateTaskController(viewModel: createTaskViewModel)
            
            createTaskController.taskCreated = { [weak self] in
                self?.navigationController.popViewController(animated: true)
            }
            
            self?.navigationController.pushViewController(createTaskController, animated: true)
        }
        
        controller.taskDetailPressed = { [weak self] taskItem in
            let taskDetailViewModel = TaskDetailViewModel(task: taskItem)
            let taskDetailController = TaskDetailController(viewModel: taskDetailViewModel)
            
            taskDetailController.taskDeleted = { [weak self] in
                self?.navigationController.popViewController(animated: true)
            }
            
            taskDetailController.taskEdit = { [weak self] taskItem in
                let createTaskViewModel = CreateTaskViewModel(createTaskState: .edit, taskItem: taskItem)
                let createTaskController = CreateTaskController(viewModel: createTaskViewModel)
                
                createTaskController.taskCreated = { [weak self] in
                    self?.navigationController.popToRootViewController(animated: true)
                }
                
                self?.navigationController.pushViewController(createTaskController, animated: true)
            }
            
            self?.navigationController.pushViewController(taskDetailController, animated: true)
        }
        
        navigationController.setViewControllers([ controller ], animated: true)
    }
}

