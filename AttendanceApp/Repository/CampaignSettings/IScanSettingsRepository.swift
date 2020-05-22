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
    func deleteActualCampaignSettings()
    func deleteAllCampaignsSettings()
}

protocol IScanSettingsImmutableRepository {
    var userSelection: ICampaignSettings {get set}
    func getObsScanSettings() -> Observable<ICampaignSettings>
    func getScanSettings() -> ICampaignSettings
}


protocol IScanSettingsRepository: IScanSettingsMutableRepository, IScanSettingsImmutableRepository {}
