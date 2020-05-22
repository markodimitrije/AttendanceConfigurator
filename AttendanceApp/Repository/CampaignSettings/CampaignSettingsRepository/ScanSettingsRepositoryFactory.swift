//
//  ScanSettingsRepositoryFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 22/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class ScanSettingsRepositoryFactory {
    static func make() -> IScanSettingsRepository {
        let dataHelper = CampaignSettingsDataHelperFactory.make()
        return ScanSettingsRepository(dataHelper: dataHelper)
    }
}
