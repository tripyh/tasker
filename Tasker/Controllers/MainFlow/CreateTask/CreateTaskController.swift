//
//  CreateTaskController.swift
//  Tasker
//
//  Created by andrey rulev on 17/03/2019.
//  Copyright © 2019 andrey rulev. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import Result

class CreateTaskController: BaseViewController {
    
    // MARK: - Public properties
    
    var taskCreated: (() -> Void)?
    
    // MARK: - Private properties
    
    @IBOutlet private var titleTextView: UITextView!
    @IBOutlet private var highPriorityButton: UIButton!
    @IBOutlet private var mediumPriorityButton: UIButton!
    @IBOutlet private var lowPriorityButton: UIButton!
    @IBOutlet private var loaderView: UIActivityIndicatorView!
    @IBOutlet private var saveButton: UIButton!
    
    private let viewModel: CreateTaskViewModel
    private let (lifetime, token) = Lifetime.make()
    
    private var showMessage: BindingTarget<String> {
        return BindingTarget(lifetime: lifetime, action: { [weak self] message in
            self?.showMessage(message)
        })
    }
    
    private var createdTask: BindingTarget<()> {
        return BindingTarget(lifetime: lifetime, action: { [weak self] in
            self?.taskCreated?()
        })
    }
    
    // MARK: - Lifecycle
    
    init(viewModel: CreateTaskViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingViewModel()
        addDismissGestureRecognizer()
        configure()
    }
}

// MARK: - Configure

private extension CreateTaskController {
    func configure() {
        titleTextView.layer.borderWidth = 1
        titleTextView.layer.borderColor = UIColor.gray.cgColor
        title = viewModel.title
        saveButton.setTitle(viewModel.saveButtonTitle, for: .normal)
        titleTextView.text = viewModel.editTaskTitle
        
        guard let taskPriorityActual = viewModel.editTaskPriority else {
            return
        }
        
        switch taskPriorityActual {
        case .High:
            selectedStyle(for: highPriorityButton)
            unselectedStyle(for: mediumPriorityButton)
            unselectedStyle(for: lowPriorityButton)
        case .Normal:
            selectedStyle(for: mediumPriorityButton)
            unselectedStyle(for: highPriorityButton)
            unselectedStyle(for: lowPriorityButton)
        case .Low:
            selectedStyle(for: lowPriorityButton)
            unselectedStyle(for: highPriorityButton)
            unselectedStyle(for: mediumPriorityButton)
        }
    }
}

// MARK: Binding

private extension CreateTaskController {
    func bindingViewModel() {
        view.reactive.isUserInteractionEnabled <~ viewModel.loading.negate()
        loaderView.reactive.isAnimating <~ viewModel.loading
        showMessage <~ viewModel.showMessage
        createdTask <~ viewModel.createdTask
    }
}

// MARK: - Actions

private extension CreateTaskController {
    @IBAction func highPriorityButtonPressed(_ sender: UIButton) {
        selectedStyle(for: sender)
        unselectedStyle(for: mediumPriorityButton)
        unselectedStyle(for: lowPriorityButton)
        viewModel.hightPrioritySelected()
    }
    
    @IBAction func mediumPriorityButtonPressed(_ sender: UIButton) {
        selectedStyle(for: sender)
        unselectedStyle(for: highPriorityButton)
        unselectedStyle(for: lowPriorityButton)
        viewModel.mediumPrioritySelected()
    }
    
    @IBAction func lowPriorityButtonPressed(_ sender: UIButton) {
        selectedStyle(for: sender)
        unselectedStyle(for: highPriorityButton)
        unselectedStyle(for: mediumPriorityButton)
        viewModel.lowPrioritySelected()
    }
    
    @IBAction func saveButtonPressed() {
        viewModel.savePressed(titleTextView.text)
    }
}

// MARK: - Private API

private extension CreateTaskController {
    func addDismissGestureRecognizer() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func selectedStyle(for sender: UIButton) {
        sender.backgroundColor = view.tintColor
        sender.tintColor = .white
    }
    
    func unselectedStyle(for sender: UIButton) {
        sender.backgroundColor = .white
        sender.tintColor = view.tintColor
    }
}
