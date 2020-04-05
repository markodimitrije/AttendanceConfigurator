//
//  IDelegate.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 05/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

protocol IDelegate {
    func getCode() -> String
    func getAllowedSessionIds() -> [Int]
}
