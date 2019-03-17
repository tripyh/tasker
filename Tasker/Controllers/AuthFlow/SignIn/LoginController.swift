//
//  LoginController.swift
//  Tasker
//
//  Created by andrey rulev on 28/02/2019.
//  Copyright © 2019 andrey rulev. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import Result

class LoginController: BaseAuthController {
    
    // MARK: - Public properties
    
    var registrationButtonPressed: (() -> Void)?
    
    // MARK: - Private properties
    
    private let viewModel: LoginViewModel
    private let (lifetime, token) = Lifetime.make()
    
    private var showMessage: BindingTarget<String> {
        return BindingTarget(lifetime: lifetime, action: { [weak self] message in
            self?.showMessage(message)
        })
    }
    
    // MARK: - Lifecycle
    
    init(viewModel: LoginViewModel) {
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
        addDismissGestureRecognizer()
    }
}

// MARK: Binding

private extension LoginController {
    func bindingViewModel() {
        view.reactive.isUserInteractionEnabled <~ viewModel.loading.negate()
        loaderView.reactive.isAnimating <~ viewModel.loading
        showMessage <~ viewModel.showMessage
    }
}

// MARK: - Actions

private extension LoginController {
    @IBAction func registerButtonPressed() {
        view.endEditing(true)
        registrationButtonPressed?()
    }
    
    @IBAction func loginButtonPressed() {
        view.endEditing(true)
        viewModel.login(email: loginTextField.text, password: passwordTextField.text)
    }
}
