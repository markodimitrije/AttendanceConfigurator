//
//  ViewBordering.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 12/06/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

protocol Bordering {
    func border(lineWidth: CGFloat, color: UIColor?)
}

extension Bordering where Self: UIView {
    var defaultColor: UIColor? {
        self.backgroundColor
    }
    func border(lineWidth: CGFloat = 1, color: UIColor? = nil) {
        self.layer.borderWidth = lineWidth
        delay(0.1) { // since we might use IBInspectables for settings bgColors
            self.layer.borderColor = color?.cgColor ?? self.backgroundColor?.cgColor
        }
    }
}
