//
//  IInitialBlockCalculatorFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 28/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class InitialBlockCalculatorFactory {
    static func make() -> IInitialBlockCalculator {
        let settings = ScanSettingsRepositoryFactory.make().getScanSettings()
        let blockRepo = BlockImmutableRepository()
        let initialRoomCalculator = InitialRoomCalculatorFactory.make()
        let initialDateCalculator = InitialDateCalculatorFactory.make()
        return InitialBlockCalculator(settings: settings,
                                      blockRepo: blockRepo,
                                      initialRoomCalculator: initialRoomCalculator,
                                      initialDateCalculator: initialDateCalculator)
    }
}
