//
//  ViewRounding.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 12/06/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

protocol Rounding {
    func round(cornerRadius: CGFloat)
}

extension Rounding where Self: UIView {
    func round(cornerRadius: CGFloat = 5) {
        self.layer.cornerRadius = cornerRadius
    }
}
