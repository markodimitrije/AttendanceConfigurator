//
//  ScanSettingsRepository.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 04/12/2018.
//  Copyright © 2018 Navus. All rights reserved.
//

import RxSwift
import RxCocoa

class ScanSettingsRepository: IScanSettingsRepository {
    
    private var initialSettings: ICampaignSettings
    
    private var campaignSettingsDataHelper: ICampaignSettingsDataHelper
    
    // API: input, output
    
    var userSelection: ICampaignSettings {
        get {
            campaignSettingsDataHelper.read()
        }
        set {
            campaignSettingsDataHelper.save(selection: newValue)
        }
    }
    
    func deleteActualCampaignSettings() {
        
    }
    
    func deleteAllCampaignsSettings() {
        
    }
    
    // API: output
    
    func getObsCampSettings() -> Observable<ICampaignSettings> {
        campaignSettingsDataHelper.getObsActualSettings()
    }
    
    func getCampSettings() -> ICampaignSettings {
        campaignSettingsDataHelper.read()
    }
    
    init(dataHelper: ICampaignSettingsDataHelper) {
        self.campaignSettingsDataHelper = dataHelper
        self.initialSettings = campaignSettingsDataHelper.read()
    }
    
    deinit {
        print("CampaignSettingsRepository.deinit")
    }
    
}
