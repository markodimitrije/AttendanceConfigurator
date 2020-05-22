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
    
    private var scanSettingsDataHelper: IScanSettingsDataHelper
    
    // API: input, output
    
    func update(settings: ICampaignSettings) {
        scanSettingsDataHelper.save(selection: settings)
    }
    func update(blockId: Int?) {
        var settings = scanSettingsDataHelper.read()
        settings.blockId = blockId
        scanSettingsDataHelper.save(selection: settings)
    }
    
    func deleteActualCampaignSettings() {
        
    }
    
    func deleteAllCampaignsSettings() {
        
    }
    
    // API: output
    
    func getObsScanSettings() -> Observable<ICampaignSettings> {
        scanSettingsDataHelper.getObsActualSettings()
    }
    
    func getScanSettings() -> ICampaignSettings {
        scanSettingsDataHelper.read()
    }
    
    init(dataHelper: IScanSettingsDataHelper) {
        self.scanSettingsDataHelper = dataHelper
        self.initialSettings = scanSettingsDataHelper.read()
    }
    
    deinit {
        print("CampaignSettingsRepository.deinit")
    }
    
}
