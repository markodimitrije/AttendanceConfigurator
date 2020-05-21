//
//  CampaignSettingsFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 21/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class CampaignSettingsFactory {
    static func make(campaignSettings: ICampaignSettings) -> RealmCampaignSettings {
        let object = RealmCampaignSettings()
        object.roomId = Int(campaignSettings.roomId!)
        object.blockId = Int(campaignSettings.blockId!)
        object.date = campaignSettings.selectedDate
        object.autoSwitch = campaignSettings.autoSwitch
        
        return object
    }
    
    static func make(rCampaignSettings: RealmCampaignSettings) -> ICampaignSettings {
        CampaignSettings(roomId: rCampaignSettings.roomId,
                         blockId: rCampaignSettings.blockId,
                         selDate: rCampaignSettings.date,
                         autoSwitch: rCampaignSettings.autoSwitch)
    }
}
