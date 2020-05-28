//
//  InitialRoomCalculatorFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 28/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class InitialRoomCalculatorFactory {
    static func make() -> IInitialRoomCalculator {
        let settings = ScanSettingsRepositoryFactory.make()
        let roomRepo = RoomRepository()
        return InitialRoomCalculator(settings: settings, roomRepo: roomRepo)
    }
}
