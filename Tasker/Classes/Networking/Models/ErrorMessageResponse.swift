//
//  ErrorMessageResponse.swift
//  Tasker
//
//  Created by andrey rulev on 17/03/2019.
//  Copyright © 2019 andrey rulev. All rights reserved.
//

import Foundation

struct ErrorMessageResponse {
    let message: String
    
    init(message: String) {
        self.message = message
    }
}

// MARK: - Decodable

extension ErrorMessageResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let message = try container.decode(String.self, forKey: .message)
        self.init(message: message)
    }
}


