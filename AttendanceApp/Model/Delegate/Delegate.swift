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
    var sessionIds = [Int]()
    
    private enum CodingKeys : String, CodingKey {
        case code = "c", sessionIds = "s"
    }
}
