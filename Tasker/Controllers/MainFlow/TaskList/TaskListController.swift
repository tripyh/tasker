//
//  TaskListController.swift
//  Tasker
//
//  Created by andrey rulev on 17/03/2019.
//  Copyright © 2019 andrey rulev. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import Result

class TaskListController: BaseViewController {
    
    // MARK: - Public properties
    
    var createNewTaskButonPressed: (() -> Void)?
    
    // MARK: - Private properties
    
    @IBOutlet private var tableView: UITableView!
    
    private var refreshControl: UIRefreshControl!
    private let viewModel: TaskListViewModel
    private let (lifetime, token) = Lifetime.make()
    
    private var showMessage: BindingTarget<String> {
        return BindingTarget(lifetime: lifetime, action: { [weak self] message in
            self?.showMessage(message)
        })
    }
    // MARK: - Lifecycle
    
    init(viewModel: TaskListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bindingViewModel()
        viewModel.loadTaskList()
    }
}

// MARK: Binding

private extension TaskListController {
    func bindingViewModel() {
        view.reactive.isUserInteractionEnabled <~ viewModel.loading.negate()
        refreshControl.reactive.isRefreshing <~ viewModel.loading
        showMessage <~ viewModel.showMessage
        tableView.reactive.reloadData <~ viewModel.reload
    }
}

// MARK: - Configure

private extension TaskListController {
    func configure() {
        title = viewModel.title
        
        tableView.register(TaskListCell.self)
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTable),
                                 for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        tableView.tableFooterView = UIView()
    }
}

// MARK: - Actions

private extension TaskListController {
    @IBAction func addTastButtonPressed() {
        createNewTaskButonPressed?()
    }
}

// MARK: - UITableViewDataSource

extension TaskListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TaskListCell = tableView.dequeueReusableCell(for: indexPath)
        let task = viewModel.task(at: indexPath.row)
        cell.configure(task)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TaskListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Private API

private extension TaskListController {
    @objc func refreshTable() {
        viewModel.loadTaskList()
    }
}
