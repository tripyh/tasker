//
//  TaskItem.swift
//  Tasker
//
//  Created by andrey rulev on 17/03/2019.
//  Copyright © 2019 andrey rulev. All rights reserved.
//

import Foundation

struct TaskItem {
    let id: Int
    let title: String
    let priority: TaskPriority
    
    init(id: Int,
         title: String,
         priority: TaskPriority) {
        self.id = id
        self.title = title
        self.priority = priority
    }
}

// MARK: - Decodable

extension TaskItem: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case priority
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let title = try container.decode(String.self, forKey: .title)
        let priority = try container.decode(TaskPriority.self, forKey: .priority)
        self.init(id: id, title: title, priority: priority)
    }
}
