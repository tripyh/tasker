//
//  TaskDetailController.swift
//  Tasker
//
//  Created by andrey rulev on 18/03/2019.
//  Copyright © 2019 andrey rulev. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import Result

class TaskDetailController: BaseViewController {
    
    // MARK: - Public properties
    
    var taskDeleted: (() -> Void)?
    var taskEdit: ((TaskItem) -> Void)?
    
    // MARK: - Private properties
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var priorityLabel: UILabel!
    @IBOutlet private var loaderView: UIActivityIndicatorView!
    
    private let viewModel: TaskDetailViewModel
    private let (lifetime, token) = Lifetime.make()
    
    private var showMessage: BindingTarget<String> {
        return BindingTarget(lifetime: lifetime, action: { [weak self] message in
            self?.showMessage(message)
        })
    }
    
    private var deletedTask: BindingTarget<()> {
        return BindingTarget(lifetime: lifetime, action: { [weak self] in
            self?.taskDeleted?()
        })
    }
    
    // MARK: - Lifecycle
    
    init(viewModel: TaskDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingViewModel()
        configure()
    }
}

// MARK: - Configure

private extension TaskDetailController {
    func configure() {
        title = viewModel.title
        titleLabel.text = viewModel.taskTitle
        priorityLabel.text = viewModel.taskPriority
        priorityLabel.textColor = viewModel.taskPriorityColor
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit,
                                         target: self,
                                         action: #selector(editButtonPressed))
        navigationItem.rightBarButtonItem = editButton
    }
}

// MARK: Binding

private extension TaskDetailController {
    func bindingViewModel() {
        view.reactive.isUserInteractionEnabled <~ viewModel.loading.negate()
        loaderView.reactive.isAnimating <~ viewModel.loading
        showMessage <~ viewModel.showMessage
        deletedTask <~ viewModel.deletedTask
    }
}

// MARK: - Actions

private extension TaskDetailController {
    @IBAction func deleteButtonPressed() {
        viewModel.deleteTask()
    }
    
    @objc func editButtonPressed() {
        taskEdit?(viewModel.taskForEdit)
    }
}
