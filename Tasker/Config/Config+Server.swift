//
//  Config+Server.swift
//  Tasker
//
//  Created by andrey rulev on 28/02/2019.
//  Copyright © 2019 andrey rulev. All rights reserved.
//

import Foundation

struct Config {
    static let serverBaseURL: URL = {
        return URL(string: "http://testapi.doitserver.in.ua/api/")!
    }()
}
