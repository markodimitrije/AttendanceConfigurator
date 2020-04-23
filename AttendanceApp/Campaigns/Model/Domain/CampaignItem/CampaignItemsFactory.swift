//
//  CampaignItemsFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 21/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class CampaignItemsFactory {
    static func make(campaigns: [ICampaign]) -> [ICampaignItem] {
        campaigns.map(self.singleItem)
        
    }
    
    static func singleItem(campaign: ICampaign) -> ICampaignItem {
        CampaignItem(id: campaign.id,
                     title: campaign.name,
                     description: campaign.description ?? "",
                     logo: campaign.logo)
    }
    
}
