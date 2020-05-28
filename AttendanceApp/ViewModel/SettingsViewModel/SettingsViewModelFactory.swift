//
//  SettingsViewModelFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 02/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class SettingsViewModelFactory {
    static func make() -> SettingsViewModel {
        let blockRepo = BlockImmutableRepositoryFactory.make()
        let scanSettingsRepo = ScanSettingsRepositoryFactory.make()
        let settingsTextCalculator =
            SettingsTextCalculator(roomTxtCalculator: RoomTxtCalculator(roomRepo: RoomRepository()),
                                   blockTxtCalculator: BlockTxtCalculator(blockRepo: blockRepo),
                                   dateTxtCalculator: DateTxtCalculator())
        return SettingsViewModel(scanSettingsRepo: scanSettingsRepo,
                                 blockRepo: blockRepo,
                                 settingsTextCalculator: settingsTextCalculator)
    }
}
