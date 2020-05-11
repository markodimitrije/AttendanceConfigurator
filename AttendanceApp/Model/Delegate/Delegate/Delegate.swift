//
//  Delegate.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 24/05/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import Foundation

extension Delegate: IDelegate {
    func getId() -> Int {self.id}
    func getCode() -> String { self.c }
    func sessionIds() -> [Int] { self.s }
}

struct Delegate: Codable {
    let id: Int
    var c: String
    var s: [Int]
}
