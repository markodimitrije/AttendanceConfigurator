//
//  StatsProtocol.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 12/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

protocol StatsProtocol: CustomStringConvertible {
    var totalTitle: String {get}
    var totalValue: String {get}
    var approvedTitle: String {get}
    var approvedValue: String {get}
    var rejectedTitle: String {get}
    var rejectedValue: String {get}
    var syncedTitle: String {get}
    var syncedValue: String {get}
}

extension StatsProtocol {
    var description: String {
        return "stats.total = " + self.approvedTitle + "/" + self.approvedValue
    }
}
