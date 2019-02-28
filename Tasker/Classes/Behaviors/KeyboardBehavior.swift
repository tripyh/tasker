//
//  KeyboardBehavior.swift
//  Tasker
//
//  Created by andrey rulev on 28/02/2019.
//  Copyright © 2019 andrey rulev. All rights reserved.
//

import UIKit

private struct Constant {
    static let AnimationDuration: TimeInterval = 0.25
}

class KeyboardBehavior: NSObject {
    var heightDidChange: (CGFloat, TimeInterval) -> Void
    
    init(heightDidChange: @escaping (CGFloat, TimeInterval) -> Void) {
        self.heightDidChange = heightDidChange
        super.init()
    }
    
    func setActive(value: Bool) {
        let center: NotificationCenter = NotificationCenter.default
        if (value) {
            center.addObserver(self, selector: #selector(KeyboardBehavior.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            center.addObserver(self, selector: #selector(KeyboardBehavior.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        } else {
            center.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            center.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        keyboardUpdated(notification: notification)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        keyboardUpdated(notification: notification)
    }
    
    private func keyboardUpdated(notification: NSNotification) {
        if let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.floatValue {
            if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let timeInterval = (duration > 0) ? TimeInterval(duration) : Constant.AnimationDuration
                let screenSize: CGRect = UIScreen.main.bounds
                let height = screenSize.height - keyboardFrame.origin.y
                heightDidChange(height, timeInterval)
            }
        }
    }
}
