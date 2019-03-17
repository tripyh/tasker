//
//  BaseAuthViewModel.swift
//  Tasker
//
//  Created by andrey rulev on 17/03/2019.
//  Copyright © 2019 andrey rulev. All rights reserved.
//

import Foundation

struct LoginParams {
    let email: String
    let password: String
}

class BaseAuthViewModel {
    enum ValidationResult {
        case success(LoginParams)
        case failure(String)
    }
}

// MARK: - Public API

extension BaseAuthViewModel {
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
}
