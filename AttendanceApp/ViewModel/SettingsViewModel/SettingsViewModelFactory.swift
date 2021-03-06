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
        return SettingsViewModel(dataAccess: DataAccess.shared,
                                 roomRepo: RoomRepository(),
                                 blockRepo: blockRepo,
                                 deviceStateReporter: DeviceStateReporter())
    }
}
