//
//  KeychainStorage.swift
//  Tasker
//
//  Created by andrey rulev on 17/03/2019.
//  Copyright © 2019 andrey rulev. All rights reserved.
//

import SwiftKeychainWrapper

private struct Constants {
    static let tokenId = "tokenId"
}

class KeychainStorage {
    
    func saveToken(_ tokenId: String) {
        KeychainWrapper.standard.set(tokenId, forKey: Constants.tokenId)
    }
    
    func tokenId() -> String? {
        return KeychainWrapper.standard.string(forKey: Constants.tokenId)
    }
}
