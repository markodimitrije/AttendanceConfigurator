//
//  CampaignSettingsDataHelper.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 19/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

protocol ICampaignSettingsDataHelper {
    func read() -> ICampaignSettings
    func save(selection: ICampaignSettings)
    func getObsActualSettings() -> Observable<ICampaignSettings>
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
    func getObsActualSettings() -> Observable<ICampaignSettings> {
        let filter = NSPredicate(format: "campaignId == %@", self.campaignId!)
        return genRepo
            .getObsObjects(ofType: RealmCampaignSettings.self, filter: filter)
            .map({ (arr) -> ICampaignSettings in
                (arr.first != nil) ?
                    CampaignSettingsFactory.make(rCampaignSettings: arr.first!) :
                    CampaignSettings()
            })
    }
    
}

struct CampaignSettingsDataHelper {
    let genRepo: IGenRepository
    let campSelectionRepo: ICampaignSelectionRepository
    var campaignId: String? {
        campSelectionRepo.getSelected()?.getCampaignId()
    }
}
