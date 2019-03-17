//
//  BaseAuthController.swift
//  Tasker
//
//  Created by andrey rulev on 17/03/2019.
//  Copyright © 2019 andrey rulev. All rights reserved.
//

import UIKit

class BaseAuthController: BaseViewController {
    
    // MARK: - Public properties
    
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loaderView: UIActivityIndicatorView!
    
    // MARK: - Private properties
    
    @IBOutlet private var scrollView: UIScrollView!
    
    private var keyboardBehavior: KeyboardBehavior?
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardBehavior?.setActive(value: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardBehavior?.setActive(value: false)
    }
}


// MARK: - Public API

extension BaseAuthController {
    func configure() {
        keyboardBehavior = KeyboardBehavior(heightDidChange: { [weak self] (height, duration) -> Void in
            guard let strongSelf = self else {
                return
            }
            
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: height, right: 0.0)
            
            UIView.animate(withDuration: TimeInterval(duration), animations: {
                strongSelf.scrollView.contentInset = contentInsets
            })
        })
    }
    
    func addDismissGestureRecognizer() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
