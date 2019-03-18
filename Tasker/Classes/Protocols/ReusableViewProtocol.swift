//
//  ReusableViewProtocol.swift
//  Tasker
//
//  Created by andrey rulev on 17/03/2019.
//  Copyright © 2019 andrey rulev. All rights reserved.
//

import UIKit

protocol ReusableViewProtocol: class {
    static var reuseIdentifier: String { get }
}

extension ReusableViewProtocol where Self: UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
