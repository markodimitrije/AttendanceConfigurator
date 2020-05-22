//
//  CampaignSettingsDataHelper.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 19/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

protocol ICampaignSettingsDataHelper {
    func read() -> ICampaignSettings
    func save(selection: ICampaignSettings)
}

extension CampaignSettingsDataHelper: ICampaignSettingsDataHelper {
    func read() -> ICampaignSettings {
        guard let campaignId = campaignId else {
            return CampaignSettings.init()
        }
        let predicate = NSPredicate(format: "campaignId == %@", campaignId)
        let rSettings = try! genRepo.getObjects(ofType: RealmCampaignSettings.self,
                                                filter: predicate).first
        if rSettings != nil {
            return CampaignSettingsFactory.make(rCampaignSettings: rSettings!)
        } else {
            return CampaignSettings.init()
        }
    }
    func save(selection: ICampaignSettings) {
        let rSettings = CampaignSettingsFactory.make(campaignSettings: selection)
        rSettings.campaignId = campaignId!
        try! genRepo.save(objects: [rSettings])
    }
}

struct CampaignSettingsDataHelper {
    let genRepo: IGenRepository
    let campSelectionRepo: ICampaignSelectionRepository
    var campaignId: String? {
        campSelectionRepo.getSelected()?.getCampaignId()
    }
}
