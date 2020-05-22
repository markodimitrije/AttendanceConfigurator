//
//  IScanSettingsRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 19/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

protocol IScanSettingsMutableRepository {
    //func setNew(settings: ICampaignSettings)
    func campaignSelected(campaignId: String)
    func deleteActualCampaignSettings()
    func deleteAllCampaignsSettings()
}

protocol IScanSettingsImmutableRepository {
    var userSelection: ICampaignSettings {get set}
    var obsDBCampSettings: Observable<ICampaignSettings> {get} // replace with this ? (DataBase)
    var dbCampSettings: ICampaignSettings {get} // replace with this ? (DataBase)
}


protocol IScanSettingsRepository: IScanSettingsMutableRepository, IScanSettingsImmutableRepository {}
