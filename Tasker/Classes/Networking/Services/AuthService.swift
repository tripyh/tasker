//
//  AuthService.swift
//  Tasker
//
//  Created by andrey rulev on 28/02/2019.
//  Copyright © 2019 andrey rulev. All rights reserved.
//

import Moya

private enum Constants {
    static let email = "email"
    static let password = "password"
}

enum AuthService: NetworkTarget {
    case login(_ params: LoginParams)
    case register(_ params: LoginParams)
    
    var path: String {
        switch self {
        case .login:
            return "auth"
        case .register:
            return "users"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Task {
        switch self {
        case .login(let params):
            let loginInfo = [Constants.email: params.email,
                             Constants.password: params.password]
            return .requestParameters(parameters: loginInfo,
                                      encoding: JSONEncoding.default)
        case .register(let params):
            let registrationInfo = [Constants.email: params.email,
                                    Constants.password: params.password]
            return .requestParameters(parameters: registrationInfo,
                                      encoding: JSONEncoding.default)
        }
    }
}

