//
//  ScanBtn.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 15/06/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

class ScanBtn: UIButton, Rounding {
    var scans: Int = 0 {
        didSet {
            update(scans: scans)
        }
    }
    private func format() {
        self.setTitleColor(.white, for: .normal)
        self.contentEdgeInsets = UIEdgeInsets(top: 8, left: 20.0, bottom: 8, right: 20.0)
        self.round(cornerRadius: self.bounds.height/2)
    }
    private func update(scans: Int) {
        let text = NSLocalizedString(key: "stats.scans") + "\(scans)"
        self.setTitle(text, for: .normal)
        self.backgroundColor = (scans != 0) ? UIColor.navusRed: UIColor.scansGray
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.format()
    }
}
