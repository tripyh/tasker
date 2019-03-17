//
//  RegistrationViewModel.swift
//  Tasker
//
//  Created by andrey rulev on 17/03/2019.
//  Copyright © 2019 andrey rulev. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import Result
import Moya

class RegistrationViewModel: BaseAuthViewModel {
    
    // MARK: - Public properties
    
    let showMessage: Signal<String, NoError>
    var loading: Property<Bool> { return Property(_loading) }
    
    // MARK: Private properties
    
    private let showMessageObserver: Signal<String, NoError>.Observer
    private let _loading: MutableProperty<Bool> = MutableProperty(false)
    private let provider: MoyaProvider<AuthService>
    private let keychainStorage = KeychainStorage()
    
    // MARK: - Lifecycle
    
    init(provider: MoyaProvider<AuthService> = MoyaProvider<AuthService>()) {
        self.provider = provider
        (showMessage, showMessageObserver) = Signal.pipe()
    }
}

// MARK: - Public API

extension RegistrationViewModel {
    func signUp(email: String?, password: String?) {
        let validationResult = validate(email: email, password: password)
        
        switch validationResult {
        case .success(let params):
            sendRegistration(params)
        case .failure(let errorMessage):
            showMessageObserver.send(value: errorMessage)
        }
    }
}

// MARK: Private API

private extension RegistrationViewModel {
    func sendRegistration(_ params: LoginParams) {
        _loading.value = true
        
        provider.reactive.request(.register(params)).start { [weak self] event in
            switch event {
            case .value(let response):
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf._loading.value = false
                
                switch response.statusCode {
                case 201:
                    do {
                        let tokenId = try JSONDecoder().decode(TokenId.self, from: response.data)
                        strongSelf.keychainStorage.saveToken(tokenId.id)
                        UIApplication.sharedCoordinator.login()
                    } catch let error {
                        strongSelf.showMessageObserver.send(value: error.localizedDescription)
                    }
                default:
                    let errorText = NSLocalizedString("Something went wrong", comment: "Error text")
                    strongSelf.showMessageObserver.send(value: errorText)
                }
                
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
