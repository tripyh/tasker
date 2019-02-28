//
//  LoginViewModel.swift
//  Tasker
//
//  Created by andrey rulev on 28/02/2019.
//  Copyright © 2019 andrey rulev. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import Result
import Moya

struct LoginParams {
    let email: String
    let password: String
}

private enum ValidationResult {
    case success(LoginParams)
    case failure(String)
}

class LoginViewModel {
    
    // MARK: - Public properties
    
    let showMessage: Signal<String, NoError>
    var loading: Property<Bool> { return Property(_loading) }
    
    // MARK: Private properties
    
    private let showMessageObserver: Signal<String, NoError>.Observer
    private let _loading: MutableProperty<Bool> = MutableProperty(false)
    private let provider: MoyaProvider<AuthService>
    
    // MARK: - Lifecycle
    
    init(provider: MoyaProvider<AuthService> = MoyaProvider<AuthService>()) {
        self.provider = provider
        (showMessage, showMessageObserver) = Signal.pipe()
    }
}

// MARK: - Public API

extension LoginViewModel {
    func login(email: String?, password: String?) {
        let validationResult = validate(email: email, password: password)
        
        switch validationResult {
        case .success(let userInfo):
            login(userInfo)
        case .failure(let errorMessage):
            showMessageObserver.send(value: errorMessage)
        }
    }
}

// MARK: Private API

private extension LoginViewModel {
    func validate(email: String?,
                  password: String?) -> ValidationResult {
        
        guard let userEmail = email,
            !userEmail.isEmpty else {
                let errorText = NSLocalizedString("Empty Email", comment: "Empty Email error text")
                let validationResult: ValidationResult = .failure(errorText)
                return validationResult
        }
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}")
        
        guard predicate.evaluate(with: userEmail) else {
            let errorText = NSLocalizedString("Wrong Email format", comment: "Wrong Email format error text")
            let validationResult: ValidationResult = .failure(errorText)
            return validationResult
        }
        
        guard let userPassword = password,
            !userPassword.isEmpty else {
                let errorText = NSLocalizedString("Empty Password", comment: "Empty Password error text")
                let validationResult: ValidationResult = .failure(errorText)
                return validationResult
        }
        
        let userInfo = LoginParams(email: userEmail, password: userPassword)
        let validationResult: ValidationResult = .success(userInfo)
        return validationResult
    }
    
    func login(_ params: LoginParams) {
        _loading.value = true
        
        provider.reactive.request(.login(params)).start { [weak self] event in
            switch event {
            case .value(let response):
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf._loading.value = false
                
            // TODO: - add functionality
                
            case let .failed(error):
                self?._loading.value = false
                self?.showMessageObserver.send(value: error.localizedDescription)
            case .interrupted:
                self?._loading.value = false
            default:
                break
            }
        }
        
    }
}
