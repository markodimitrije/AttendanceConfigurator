//
//  Delegate.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 24/05/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import Foundation

struct Delegates: Codable {
    var delegates: [Delegate]
}

struct Delegate: Codable {
    var code: String
}
