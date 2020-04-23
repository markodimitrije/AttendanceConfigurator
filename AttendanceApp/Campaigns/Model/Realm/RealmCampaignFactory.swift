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
        rCampaign.conferenceId = campaign.conferenceId
        rCampaign.restrictedAccess = campaign.restrictedAccess
        rCampaign.createdAt = campaign.createdAt
        rCampaign.updatedAt = campaign.updatedAt
        rCampaign.deletedAt = campaign.deletedAt
        rCampaign.imgData = campaign.image?.pngData()
        return rCampaign
    }
}
