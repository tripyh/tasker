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
    
    var path: String {
        return "tasks"
    }
    
    var method: Moya.Method {
        switch self {
        case .taskList:
            return .get
        case .newTask:
            return .post
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
