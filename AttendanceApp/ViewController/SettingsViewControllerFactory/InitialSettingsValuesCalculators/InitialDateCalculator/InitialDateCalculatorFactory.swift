//
//  InitialDateCalculatorFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 28/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class InitialDateCalculatorFactory {
    static func make() -> IInitialDateCalculator {
        let settings = ScanSettingsRepositoryFactory.make()
        let blockRepo = BlockImmutableRepository()
        return InitialDateCalculator(settings: settings, blockRepo: blockRepo)
    }
}
