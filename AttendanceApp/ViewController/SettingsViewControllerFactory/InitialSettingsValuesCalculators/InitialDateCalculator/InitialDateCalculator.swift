//
//  InitialDateCalculator.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 28/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

protocol IInitialDateCalculator {
    func getDate() -> Date?
}

struct InitialDateCalculator: IInitialDateCalculator {
    let settings: IScanSettingsRepository
    let blockRepo: IBlockImmutableRepository
    func getDate() -> Date? {
        let savedDate = settings.getScanSettings().selectedDate
        var date: Date?
        if savedDate != nil {
            date = savedDate
        } else {
            let dates = blockRepo.getAvailableDates(roomId: settings.getScanSettings().roomId)
            date = (dates.count == 1) ? dates.first : nil
        }
        return date
    }
}
