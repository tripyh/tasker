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
    
    var color: UIColor {
        switch self {
        case .High:
            return .red
        case .Normal:
            return UIColor(red: 0/255.0, green: 122/255.0, blue: 1, alpha: 1.0)
        case .Low:
            return .green
        }
    }
}

struct NewTaskParams {
    let title: String
    let priority: TaskPriority
}

private enum ValidationResult {
    case success(NewTaskParams)
    case failure(String)
}

enum CreateTaskState {
    case new
    case edit
}

class CreateTaskViewModel {
    
    // MARK: - Public properties
    
    let showMessage: Signal<String, NoError>
    var loading: Property<Bool> { return Property(_loading) }
    let createdTask: Signal<(), NoError>
    
    var title: String {
        switch createTaskState {
        case .new:
            return NSLocalizedString("Create task", comment: "Create task title")
        case .edit:
            return NSLocalizedString("Edit task", comment: "Create task title")
        }
    }
    
    var saveButtonTitle: String {
        switch createTaskState {
        case .new:
            return NSLocalizedString("Save", comment: "Save button title")
        case .edit:
            return NSLocalizedString("Update", comment: "Save button title")
        }
    }
    
    var editTaskTitle: String? {
        return taskItem?.title
    }
    
    var editTaskPriority: TaskPriority? {
        return taskItem?.priority
    }
    
    // MARK: - Private properties
    
    private let showMessageObserver: Signal<String, NoError>.Observer
    private let _loading: MutableProperty<Bool> = MutableProperty(false)
    private let createdTaskObserver: Signal<(), NoError>.Observer
    private let provider: MoyaProvider<TaskService>
    private let createTaskState: CreateTaskState
    
    private var taskTitle: String?
    private var taskPriority: TaskPriority?
    private let taskItem: TaskItem?
    
    init(provider: MoyaProvider<TaskService> = MoyaProvider<TaskService>(),
         createTaskState: CreateTaskState,
         taskItem: TaskItem?) {
        self.provider = provider
        self.createTaskState = createTaskState
        self.taskItem = taskItem
        taskPriority = taskItem?.priority
        taskTitle = taskItem?.title
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
    
    func savePressed(_ titleText: String) {
        taskTitle = titleText
        
        let validationResult = validate()
        
        switch validationResult {
        case .success(let newTask):
            switch createTaskState {
            case .new:
                createNewTask(newTask)
            case .edit:
                guard let taskActual = taskItem else {
                    let taskErrorMessage = NSLocalizedString("Task not valid", comment: "Task error message")
                    showMessageObserver.send(value: taskErrorMessage)
                    return
                }
                let updatedtask = TaskItem(id: taskActual.id,
                                           title: newTask.title,
                                           priority: newTask.priority)
                updateTask(updatedtask)
            }
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
    
    func updateTask(_ updatedTask: TaskItem) {
        _loading.value = true
        
        provider.reactive.request(.update(updatedTask)).start { [weak self] event in
            switch event {
            case .value(let response):
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf._loading.value = false
                
                switch response.statusCode {
                case 202:
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
