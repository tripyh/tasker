//
//  TokenId.swift
//  Tasker
//
//  Created by andrey rulev on 17/03/2019.
//  Copyright © 2019 andrey rulev. All rights reserved.
//

import Foundation

struct TokenId {
    let id: String
    
    init(id: String) {
        self.id = id
    }
}

// MARK: - Decodable

extension TokenId: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "token"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        self.init(id: id)
    }
}
