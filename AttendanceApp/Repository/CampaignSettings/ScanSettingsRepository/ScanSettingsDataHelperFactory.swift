//
//  ScanSettingsDataHelperFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 21/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class ScanSettingsDataHelperFactory {
    static func make() -> IScanSettingsDataHelper {
        ScanSettingsDataHelper(genRepo: GenericRepository(),
                               campSelectionRepo: CampaignSelectionRepositoryFactory.make())
    }
}
