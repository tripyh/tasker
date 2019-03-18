//
//  TaskListViewModel.swift
//  Tasker
//
//  Created by andrey rulev on 17/03/2019.
//  Copyright © 2019 andrey rulev. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import Result
import Moya

class TaskListViewModel {
    
    // MARK: - Public properties
    
    let reload: Signal<(), NoError>
    let showMessage: Signal<String, NoError>
    var loading: Property<Bool> { return Property(_loading) }
    
    var title: String {
        return NSLocalizedString("My Tasks", comment: "TaskList title")
    }
    
    // MARK: - Private properties
    
    private let reloadObserver: Signal<(), NoError>.Observer
    private let showMessageObserver: Signal<String, NoError>.Observer
    private let _loading: MutableProperty<Bool> = MutableProperty(false)
    private let provider: MoyaProvider<TaskService>
    private let keychainStorage = KeychainStorage()
    
    private var taskArr = [TaskItem]()
    
    // MARK: - Lifecycle
    
    init(provider: MoyaProvider<TaskService> = MoyaProvider<TaskService>()) {
        self.provider = provider
        (showMessage, showMessageObserver) = Signal.pipe()
        (reload, reloadObserver) = Signal.pipe()
    }
}

// MARK: Data Source

extension TaskListViewModel {
    var numberOfRows: Int {
        return taskArr.count
    }
    
    func task(at index: Int) -> TaskItem? {
        guard 0..<taskArr.count ~= index else {
            return nil
        }
        
        return taskArr[index]
    }
}

// MARK: - Piblic API

extension TaskListViewModel {
    func loadTaskList() {
        _loading.value = taskArr.isEmpty
        
        provider.reactive.request(.taskList).start { [weak self] event in
            switch event {
            case .value(let response):
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf._loading.value = false
                
                do {
                    let taskItems = try JSONDecoder().decode(TaskItems.self, from: response.data)
                    strongSelf.taskArr = taskItems.tasks
                    strongSelf.reloadObserver.send(value: ())
                } catch let error {
                    strongSelf.showMessageObserver.send(value: error.localizedDescription)
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
