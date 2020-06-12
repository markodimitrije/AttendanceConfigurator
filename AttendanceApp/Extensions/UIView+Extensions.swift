//
//  UIView+Extensions.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 12/06/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

protocol Rounding {
    func round(cornerRadius: CGFloat)
}
protocol Bordering {
    func border(lineWidth: CGFloat, color: UIColor?)
}

extension Rounding where Self: UIView {
    func round(cornerRadius: CGFloat = 5) {
        self.layer.cornerRadius = cornerRadius
    }
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

class RefreshResourcesBtn: ActionUIButton, Rounding, Bordering {
    override init(frame: CGRect) {
        super.init(frame: frame)
        format()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        format()
    }
    private func format() {
        self.round(cornerRadius: self.bounds.height/2)
        self.border()
    }
}

class SaveSettingsAndExitBtn: UIButton, Rounding, Bordering {
    override init(frame: CGRect) {
        super.init(frame: frame)
        format()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        format()
    }
    override var alpha: CGFloat {
        didSet {
            format()
        }
    }
    override var isEnabled: Bool {
        didSet {
            format()
        }
    }
    func format() {
        self.round(cornerRadius: self.bounds.height/2)
        let color = self.isEnabled ? self.tintColor : UIColor.lightGray
        self.border(lineWidth: 1.0, color: color)
    }
}
