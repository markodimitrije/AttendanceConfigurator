//
//  RealmCampaignFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 21/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RealmSwift

class RealmCampaignFactory {
    static func make(campaign: ICampaign) -> RealmCampaign {
        let rCampaign = RealmCampaign()
        rCampaign.id = campaign.id
        rCampaign.name = campaign.name
        rCampaign.desc = campaign.description
        rCampaign.logo = campaign.logo
        rCampaign.createdAt = campaign.createdAt
        if let img = campaign.image, let data = img.pngData() {
            rCampaign.image = data
        }
        return rCampaign
    }
}
