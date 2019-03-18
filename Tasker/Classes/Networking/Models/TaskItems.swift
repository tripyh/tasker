//
//  TaskItems.swift
//  Tasker
//
//  Created by andrey rulev on 18/03/2019.
//  Copyright © 2019 andrey rulev. All rights reserved.
//

import Foundation

struct TaskItems {
    let tasks: [TaskItem]
    
    init(tasks: [TaskItem]) {
        self.tasks = tasks
    }
}

// MARK: - Decodable

extension TaskItems: Decodable {
    private enum CodingKeys: String, CodingKey {
        case task = "tasks"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let tasks = try container.decode([TaskItem].self, forKey: .task)
        self.init(tasks: tasks)
    }
}
