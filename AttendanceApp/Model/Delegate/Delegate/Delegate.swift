//
//  Delegate.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 24/05/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import Foundation

extension Delegate: IDelegate {
    func getCode() -> String { self.c }
    func blockIds() -> [Int] { self.s }
}

struct Delegate: Codable {
    var c: String
    var s: [Int]
}
