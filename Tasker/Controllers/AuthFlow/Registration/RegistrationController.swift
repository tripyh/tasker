//
//  RegistrationController.swift
//  Tasker
//
//  Created by andrey rulev on 17/03/2019.
//  Copyright © 2019 andrey rulev. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import Result

class RegistrationController: BaseAuthController {
    
    // MARK: - Private properties
    
    private let viewModel: RegistrationViewModel
    private let (lifetime, token) = Lifetime.make()
    
    private var showMessage: BindingTarget<String> {
        return BindingTarget(lifetime: lifetime, action: { [weak self] message in
            self?.showMessage(message)
        })
    }
    
    // MARK: - Lifecycle
    
    init(viewModel: RegistrationViewModel) {
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

private extension RegistrationController {
    func bindingViewModel() {
        view.reactive.isUserInteractionEnabled <~ viewModel.loading.negate()
        loaderView.reactive.isAnimating <~ viewModel.loading
        showMessage <~ viewModel.showMessage
    }
}

// MARK: - Actions

private extension RegistrationController {
    @IBAction func signUpButtonPressed() {
        view.endEditing(true)
        viewModel.signUp(email: loginTextField.text,
                         password: passwordTextField.text)
    }
}
