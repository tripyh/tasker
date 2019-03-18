//
//  NibLoadableViewProtocol.swift
//  Tasker
//
//  Created by andrey rulev on 17/03/2019.
//  Copyright © 2019 andrey rulev. All rights reserved.
//

import UIKit

protocol NibLoadableViewProtocol: class {
    static var nibName: String { get }
}

extension NibLoadableViewProtocol where Self: UITableViewCell {
    static var nibName: String {
        return String(describing: self)
    }
}
