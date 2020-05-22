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
    
    lazy private var _settingsSelected =
        BehaviorRelay<ICampaignSettings>.init(value: initialSettings)
    
    private var initialSettings: ICampaignSettings
    
    private var campaignSettingsDataHelper: ICampaignSettingsDataHelper
    
    private var campaignId: String = ""
    
    func campaignSelected(campaignId: String) {
        self.campaignId = campaignId
        let existingSettings = campaignSettingsDataHelper.read()
        postUpdateOnOutput(userSelection: existingSettings)
    }
    
    // API: input, output
    
    
    
    var userSelection: ICampaignSettings {
        get {
            campaignSettingsDataHelper.read()
        }
        set {
            campaignSettingsDataHelper.save(selection: newValue)
            postUpdateOnOutput(userSelection: newValue)
        }
    }
    
    private func postUpdateOnOutput(userSelection: ICampaignSettings) {
        _settingsSelected.accept(userSelection)
    }
    
    func deleteActualCampaignSettings() {
        _settingsSelected.accept(CampaignSettings())
    }
    
    func deleteAllCampaignsSettings() {
        _settingsSelected.accept(CampaignSettings())
    }
    
    // API: output
    
    var obsDBCampSettings: Observable<ICampaignSettings> {
        campaignSettingsDataHelper.getObsActualSettings()
    }
    
    var dbCampSettings: ICampaignSettings {
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
