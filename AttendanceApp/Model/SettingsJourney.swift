//
//  SettingsJourney.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 24/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

struct SettingsJourney {
    var roomId: Int?
    var blockId: Int?
    var date: Date?
    var autoSwitch: Bool
    init() {
        self.roomId = DataAccess.shared.userSelection.roomId
        self.blockId = DataAccess.shared.userSelection.blockId
        self.date = DataAccess.shared.userSelection.selectedDate
        self.autoSwitch = DataAccess.shared.userSelection.autoSwitch
    }
}

extension SettingsJourney: CustomStringConvertible {
    var description: String {
        return "UserSelection.description: \nroomId = \(String(describing: roomId))\nblockId = \(String(describing: blockId))\ndate = \(String(describing: date))\nautoSwitch = \(autoSwitch)"
    }
}
