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
        return SettingsViewModel(scanSettingsRepo: scanSettingsRepo,
                                 blockRepo: blockRepo,
                                 roomTxtFactory: RoomTxtFactory(roomRepo: RoomRepository()),
                                 blockTxtFactory: BlockTxtFactory(blockRepo: blockRepo),
                                 dateTxtFactory: DateTxtFactory())
    }
}
