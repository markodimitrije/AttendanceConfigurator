//
//  IScanSettings.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 19/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

protocol IScanSettings {
    var roomId: Int? {get}
    var blockId: Int? {get set} // set because of autoSession timer
    var selectedDate: Date? {get}
    var autoSwitch: Bool {get}
}

