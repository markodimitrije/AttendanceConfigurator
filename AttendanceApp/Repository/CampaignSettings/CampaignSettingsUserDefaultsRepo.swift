//
//  CampaignSettingsUserDefaultsRepo.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 19/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class CampaignSettingsUserDefaultsRepo {
    static func read(campaignId: String) -> ICampaignSettings {
        guard let settings = UserDefaults.standard.value(forKey: "campaignId" + campaignId) as? [String: Any] else {
            return CampaignSettings()
        }
        return CampaignSettings(roomId: settings["roomId"] as? Int,
                                blockId: settings["blockId"] as? Int,
                                selDate: settings["date"] as? Date,
                                autoSwitch: settings["autoSwitch"] as? Bool ?? true)
    }
    static func save(selection: ICampaignSettings, campaignId: String) {
        var settings = [String : Any]()
        if selection.roomId != nil { settings["roomId"] = selection.roomId }
        if selection.blockId != nil { settings["blockId"] = selection.blockId }
        if selection.selectedDate != nil { settings["date"] = selection.selectedDate }
        settings["autoSwitch"] = selection.autoSwitch
        UserDefaults.standard.set(settings, forKey: "campaignId" + campaignId)
    }
}