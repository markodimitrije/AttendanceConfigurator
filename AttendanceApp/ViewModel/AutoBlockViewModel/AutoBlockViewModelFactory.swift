//
//  AutoBlockViewModelFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 08/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class AutoBlockViewModelFactory {
    static func make(roomId: Int, date: Date?) -> AutoBlockViewModel {
        let blockViewModel = BlockViewModelFactory.make(roomId: roomId, date: date)
        let scanSettingsRepo = ScanSettingsRepositoryFactory.make()
        return AutoBlockViewModel(blockViewModel: blockViewModel,
                                  scanSettingsRepo: scanSettingsRepo)
    }
}
