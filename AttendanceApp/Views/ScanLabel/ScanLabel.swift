//
//  ScanLabel.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 15/06/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

class ScanLabel: UIButton, Rounding {
    var scans: Int = 0 {
        didSet {
            update(scans: scans)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        format()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        format()
    }
    
    private func format() {
        //self.titleEdgeInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
        self.setTitleColor(.white, for: .normal)
        self.round(cornerRadius: self.bounds.height/2)
    }
    
    private func update(scans: Int) {
        let text = NSLocalizedString(key: "stats.scans") + "\(scans)"
        self.setTitle(text, for: .normal)
        self.backgroundColor = (scans != 0) ? UIColor.navusRed: UIColor.scansGray
    }
}
