//
//  SaveSettingsAndExitBtn.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 12/06/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

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
        self.setTitle(NSLocalizedString(key: "saveSettingsAndExit"),
                      for: .normal)
        self.round(cornerRadius: self.bounds.height/2)
        let color = self.isEnabled ? self.tintColor : UIColor.lightGray
        self.border(lineWidth: 1.0, color: color)
    }
}
