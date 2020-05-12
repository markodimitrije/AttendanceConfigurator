//
//  NSObject+Extension.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 12/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

extension NSObject {
    func NSLocalizedString(key: String) -> String {
        return Foundation.NSLocalizedString(key, comment: "")
    }
}
