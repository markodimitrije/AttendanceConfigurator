//
//  RefreshResourcesBtn.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 12/06/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

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
        self.setTitle(NSLocalizedString(key: "refreshResources"),
                      for: .normal)
        self.round(cornerRadius: self.bounds.height/2)
        self.border()
    }
}