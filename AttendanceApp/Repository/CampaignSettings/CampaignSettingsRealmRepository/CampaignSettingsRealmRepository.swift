//
//  CampaignSettingsRealmRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 20/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift
import RealmSwift

extension CampaignSettingsRealmRepository: ICampaignSettingsRepository {
    
    func campaignSelected(campaignId: String) {
        
        campSettings = genericRepo.
        _obsCampSettings.onNext(campSettings)
//        let existingSettings = CampaignSettingsUserDefaultsRepo.read(campaignId: campaignId)
//        postUpdateOnOutput(userSelection: existingSettings)
    }
    
    var obsCampSettings: Observable<ICampaignSettings> {
        return _obsCampSettings.asObservable()
    }
    
    func deleteActualCampaignSettings() {
        fatalError("deleteActualCampaignSettings.implement me")
    }
    
    func deleteAllCampaignsSettings() {
        _ = genericRepo.deleteAllObjects(ofTypes: [RealmCampaignSettings.self])
    }
    
}

struct CampaignSettingsRealmRepository {
    var userSelection: ICampaignSettings
    private let _obsCampSettings = PublishSubject<ICampaignSettings>()
    let genericRepo: IGenericRealmRepository
}






class RealmCampaignSettings: Object {
    @objc dynamic var campaignId = ""
    @objc dynamic var roomId = 0
    @objc dynamic var blockId = 0
    @objc dynamic var date: Date?
    @objc dynamic var autoSwitch = true
    
    override class func primaryKey() -> String? {
        "campaignId"
    }
}

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
