//
//  Delegate.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 24/05/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import Foundation

struct Delegates: Codable {
    var current_time = ""
    var delegates = [Delegate]()
}

//struct Delegate: Codable {
//    var code: String
//    var sessionIds = [Int]()
//
//    enum CodingKeys : String, CodingKey {
//        case code = "c", sessionIds = "s"
//    }
//}

struct Delegate: Codable {
    var c: String
    var s: [Int]
}
