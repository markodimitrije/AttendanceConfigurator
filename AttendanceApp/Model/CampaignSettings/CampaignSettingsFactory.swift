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
        let roomId = (campaignSettings.roomId != nil) ? "\(campaignSettings.roomId!)" : nil
        let blockId = (campaignSettings.blockId != nil) ? "\(campaignSettings.blockId!)" : nil
        object.roomId = roomId
        object.blockId = blockId
        object.date = campaignSettings.selectedDate
        object.autoSwitch = campaignSettings.autoSwitch
        
        return object
    }
    
    static func make(rCampaignSettings: RealmCampaignSettings) -> ICampaignSettings {
        let roomId = (rCampaignSettings.roomId != nil) ? Int(rCampaignSettings.roomId!) : nil
        let blockId = (rCampaignSettings.blockId != nil) ? Int(rCampaignSettings.blockId!) : nil
        return CampaignSettings(roomId: roomId,
                                blockId: blockId,
                                selDate: rCampaignSettings.date,
                                autoSwitch: rCampaignSettings.autoSwitch)
    }
}
