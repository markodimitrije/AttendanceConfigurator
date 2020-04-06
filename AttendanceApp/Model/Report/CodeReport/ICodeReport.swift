//
//  ICodeReport.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 31/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

protocol ICodeReport {
    func getCode() -> String
    func getSessionId() -> Int
    func getDate() -> Date
    func isReported() -> Bool
    func isAccepted() -> Bool
}
