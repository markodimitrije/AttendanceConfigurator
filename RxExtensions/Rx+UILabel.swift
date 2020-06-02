//
//  Rx+UILabel.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 02/06/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxCocoa
import RxSwift

extension Reactive where Base: UILabel {
    public var textColor: Binder<UIColor?> {
        return Binder(self.base) { label, color in
            label.textColor = color
        }
    }
}


