//
//  NetworkProvider.swift
//  Tasker
//
//  Created by andrey rulev on 28/02/2019.
//  Copyright © 2019 andrey rulev. All rights reserved.
//

import Moya

protocol NetworkTarget: TargetType {
    
}

extension NetworkTarget {
    var baseURL: URL {
        return Config.serverBaseURL
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        return [:]
    }
}
