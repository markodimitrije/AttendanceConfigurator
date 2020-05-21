//
//  CampaignSettingsRealmRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 20/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift
import RealmSwift

extension CampaignSettingsRealmRepository: ICampaignSettingsRepository { // TODO marko: without Realm
    
    func campaignSelected(campaignId: String) {
        
        let rCampSettings =
            try! genericRepo.getObjects(ofType: RealmCampaignSettings.self,
                                        filter: NSPredicate(format: "id == %@", campaignId)).first
        
        let campSettings = (rCampSettings != nil) ?
            CampaignSettingsFactory.make(rCampaignSettings: rCampSettings!): CampaignSettings()
        
        _obsCampSettings.onNext(campSettings)
    }
    
    var obsCampSettings: Observable<ICampaignSettings> {
        return _obsCampSettings.asObservable()
    }
    
    func deleteActualCampaignSettings() {
        fatalError("deleteActualCampaignSettings.implement me") // TODO MARKO
    }
    
    func deleteAllCampaignsSettings() {
        try? genericRepo.delete(type: RealmCampaignSettings.self)
    }
    
}

struct CampaignSettingsRealmRepository {
    var userSelection: ICampaignSettings
    private let _obsCampSettings = PublishSubject<ICampaignSettings>()
    let genericRepo: IGenRepository
}

