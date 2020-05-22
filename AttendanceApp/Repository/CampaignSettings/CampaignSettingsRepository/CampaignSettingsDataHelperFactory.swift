//
//  CampaignSettingsDataHelperFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 21/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class CampaignSettingsDataHelperFactory {
    static func make() -> ICampaignSettingsDataHelper {
        CampaignSettingsDataHelper(genRepo: GenericRepository(),
                                   campSelectionRepo: CampaignSelectionRepositoryFactory.make())
    }
}
