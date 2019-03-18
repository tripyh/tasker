//
//  TaskDetailViewModel.swift
//  Tasker
//
//  Created by andrey rulev on 18/03/2019.
//  Copyright © 2019 andrey rulev. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import Result
import Moya

class TaskDetailViewModel {
    
    // MARK: - Public properties
    
    let showMessage: Signal<String, NoError>
    var loading: Property<Bool> { return Property(_loading) }
    let deletedTask: Signal<(), NoError>
    
    var taskForEdit: TaskItem {
        return task
    }
    
    var title: String {
        return NSLocalizedString("Task Detail", comment: "Task Detail title")
    }
    
    var taskTitle: String {
        return task.title
    }
    
    var taskPriority: String {
        return task.priority.rawValue
    }
    
    var taskPriorityColor: UIColor {
        return task.priority.color
    }
    
    // MARK: - Private properties
    
    private let showMessageObserver: Signal<String, NoError>.Observer
    private let _loading: MutableProperty<Bool> = MutableProperty(false)
    private let deletedTaskObserver: Signal<(), NoError>.Observer
    private let provider: MoyaProvider<TaskService>
    
    private let task: TaskItem
    
    // MARK: - Lifecycle
    
    init(task: TaskItem,
         provider: MoyaProvider<TaskService> = MoyaProvider<TaskService>()) {
        self.task = task
        self.provider = provider
        (showMessage, showMessageObserver) = Signal.pipe()
        (deletedTask, deletedTaskObserver) = Signal.pipe()
    }
}

// MARK: - Public API

extension TaskDetailViewModel {
    func deleteTask() {
        _loading.value = true
        
        provider.reactive.request(.delete(task.id)).start { [weak self] event in
            switch event {
            case .value(let response):
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf._loading.value = false
                
                switch response.statusCode {
                case 202:
                    strongSelf.deletedTaskObserver.send(value: ())
                default:
                    let errorText = NSLocalizedString("Something went wrong", comment: "Error text")
                    strongSelf.showMessageObserver.send(value: errorText)
                }
                
            case let .failed(error):
                self?._loading.value = false
                self?.showMessageObserver.send(value: error.localizedDescription)
            case .interrupted:
                self?._loading.value = false
            default:
                break
            }
        }
    }
}
