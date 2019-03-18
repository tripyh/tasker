//
//  TaskListCell.swift
//  Tasker
//
//  Created by andrey rulev on 17/03/2019.
//  Copyright © 2019 andrey rulev. All rights reserved.
//

import UIKit

class TaskListCell: BaseTableViewCell {
    
    // MARK: Private properties
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var priorityLabel: UILabel!
    
    // MARK: - Configure
    
    func configure(_ task: TaskItem?) {
        titleLabel.text = task?.title
        priorityLabel.text = task?.priority.rawValue
        
        guard let taskActual = task else {
            return
        }
        
        switch taskActual.priority {
        case .High:
            priorityLabel.textColor = .red
        case .Normal:
            priorityLabel.textColor = contentView.tintColor
        case .Low:
            priorityLabel.textColor = .green
        }
    }
}
