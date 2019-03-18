//
//  TaskService.swift
//  Tasker
//
//  Created by andrey rulev on 17/03/2019.
//  Copyright © 2019 andrey rulev. All rights reserved.
//

import Moya

private struct Constants {
    static let title = "title"
    static let priority = "priority"
}

enum TaskService: NetworkTarget {
    case taskList
    case newTask(_ taskParams: NewTaskParams)
    case delete(_ taskId: Int)
    case update(_ taskParams: TaskItem)
    
    var path: String {
        switch self {
        case .taskList, .newTask:
            return "tasks"
        case .delete(let taskId):
            return "tasks/\(taskId)"
        case .update(let task):
            return "tasks/\(task.id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .taskList:
            return .get
        case .newTask:
            return .post
        case .delete:
            return .delete
        case .update:
            return .put
        }
    }
    
    var task: Task {
        switch self {
        case .taskList:
            return .requestPlain
        case .newTask(let newTaskParams):
            let newTask = [Constants.title: newTaskParams.title,
                             Constants.priority: newTaskParams.priority.rawValue]
            return .requestParameters(parameters: newTask,
                                      encoding: JSONEncoding.default)
        case .delete:
            return .requestPlain
        case .update(let task):
            let newTask = [Constants.title: task.title,
                           Constants.priority: task.priority.rawValue]
            return .requestParameters(parameters: newTask,
                                      encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        let keychainStorage = KeychainStorage()
        
        if let tokenId = keychainStorage.tokenId() {
            return ["Authorization": "Bearer \(tokenId)"]
        } else {
            return [:]
        }
    }
}
