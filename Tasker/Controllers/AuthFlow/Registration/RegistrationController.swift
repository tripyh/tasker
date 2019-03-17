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

class RegistrationController: BaseViewController {
    
    // MARK: - Private properties
    
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var loginTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var loaderView: UIActivityIndicatorView!
    
    private let viewModel: RegistrationViewModel
    private var keyboardBehavior: KeyboardBehavior?
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardBehavior?.setActive(value: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardBehavior?.setActive(value: false)
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

// MARK: - Configure

private extension RegistrationController {
    func configure() {
        keyboardBehavior = KeyboardBehavior(heightDidChange: { [weak self] (height, duration) -> Void in
            guard let strongSelf = self else {
                return
            }

            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: height, right: 0.0)
            
            UIView.animate(withDuration: TimeInterval(duration), animations: {
                strongSelf.scrollView.contentInset = contentInsets
            })
        })
    }
    
    func addDismissGestureRecognizer() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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

