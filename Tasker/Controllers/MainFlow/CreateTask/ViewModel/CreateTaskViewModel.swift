//
//  CreateTaskViewModel.swift
//  Tasker
//
//  Created by andrey rulev on 17/03/2019.
//  Copyright © 2019 andrey rulev. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import Result
import Moya

enum TaskPriority: String, Decodable {
    case Low, Normal, High
}

struct NewTaskParams {
    let title: String
    let priority: TaskPriority
}

private enum ValidationResult {
    case success(NewTaskParams)
    case failure(String)
}

class CreateTaskViewModel {
    
    // MARK: - Public properties
    
    let showMessage: Signal<String, NoError>
    var loading: Property<Bool> { return Property(_loading) }
    let createdTask: Signal<(), NoError>
    
    var title: String {
        return NSLocalizedString("Create task", comment: "Create task title")
    }
    
    // MARK: - Private properties
    
    private let showMessageObserver: Signal<String, NoError>.Observer
    private let _loading: MutableProperty<Bool> = MutableProperty(false)
    private let createdTaskObserver: Signal<(), NoError>.Observer
    private let provider: MoyaProvider<TaskService>
    
    private var taskTitle: String?
    private var taskPriority: TaskPriority?
    
    init(provider: MoyaProvider<TaskService> = MoyaProvider<TaskService>()) {
        self.provider = provider
        (showMessage, showMessageObserver) = Signal.pipe()
        (createdTask, createdTaskObserver) = Signal.pipe()
    }
}

// MARK: - Public API

extension CreateTaskViewModel {
    func hightPrioritySelected() {
        taskPriority = .High
    }
    
    func mediumPrioritySelected() {
        taskPriority = .Normal
    }
    
    func lowPrioritySelected() {
        taskPriority = .Low
    }
    
    func continuePressed(_ titleText: String) {
        taskTitle = titleText
        
        let validationResult = validate()
        
        switch validationResult {
        case .success(let newTask):
            createNewTask(newTask)
        case .failure(let message):
            showMessageObserver.send(value: message)
        }
    }
}

// MARK: - Private API

private extension CreateTaskViewModel {
    func validate() -> ValidationResult {
        let validationResult: ValidationResult
        
        guard let priorityActual = taskPriority else {
            let message = NSLocalizedString("Priority not selected", comment: "Empty priority message")
            validationResult = .failure(message)
            return validationResult
        }
        
        guard let titleActual = taskTitle, !titleActual.isEmpty else {
            let message = NSLocalizedString("Empty title", comment: "Empty title message")
            validationResult = .failure(message)
            return validationResult
        }
        
        let newTask = NewTaskParams(title: titleActual,
                                    priority: priorityActual)
        validationResult = .success(newTask)
        return validationResult
    }
    
    func createNewTask(_ newTask: NewTaskParams) {
        _loading.value = true
        
        provider.reactive.request(.newTask(newTask)).start { [weak self] event in
            switch event {
            case .value(let response):
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf._loading.value = false
                
                switch response.statusCode {
                case 201:
                    strongSelf.createdTaskObserver.send(value: ())
                case 403, 422:
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorMessageResponse.self, from: response.data)
                        strongSelf.showMessageObserver.send(value: errorResponse.message)
                    } catch let error {
                        strongSelf.showMessageObserver.send(value: error.localizedDescription)
                    }
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
