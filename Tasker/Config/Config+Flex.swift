//
//  Config+Flex.swift
//  Tasker
//
//  Created by andrey rulev on 28/02/2019.
//  Copyright © 2019 andrey rulev. All rights reserved.
//

import UIKit
import FLEX

extension Config {
    enum FlexAppearanceMode {
        case none
        case shake
    }
    
    static var currentFlexAppearanceMode: FlexAppearanceMode {
        return .shake
    }
    
    static func configureFlex() {
        FLEXManager.shared().isNetworkDebuggingEnabled = true
    }
}

// MARK: Motions for FLEX

extension UIWindow {
    override open var canBecomeFirstResponder: Bool {
        switch Config.currentFlexAppearanceMode {
        case .shake:
            return true
        default:
            return false
        }
    }
    
    override open func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard Config.currentFlexAppearanceMode == .shake else {
            return
        }
        
        if motion == .motionShake {
            if FLEXManager.shared().isHidden {
                FLEXManager.shared().showExplorer()
            } else {
                FLEXManager.shared().hideExplorer()
            }
        }
    }
}
