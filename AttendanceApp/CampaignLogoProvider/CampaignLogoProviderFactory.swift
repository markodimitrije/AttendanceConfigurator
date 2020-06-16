//
//  CampaignLogoProviderFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/06/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class CampaignLogoProviderFactory {
    static func make() -> ICampaignLogoProvider {
        let campaignSelectionRepo = CampaignSelectionRepositoryFactory.make()
        let campaignsRepo = CampaignsRepositoryFactory.make()
        return CampaignLogoProvider(campaignSelectionRepo: campaignSelectionRepo,
                                    campaignsRepo: campaignsRepo,
                                    imageProvider: ImageProvider())
    }
}
