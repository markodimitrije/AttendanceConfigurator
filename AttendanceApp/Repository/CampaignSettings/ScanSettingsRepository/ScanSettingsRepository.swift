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
    
    private var initialSettings: IScanSettings
    
    private var scanSettingsDataHelper: IScanSettingsDataHelper
    
    // API: input, output
    
    func update(settings: IScanSettings) {
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
    
    func getObsScanSettings() -> Observable<IScanSettings> {
        scanSettingsDataHelper.getObsActualSettings()
    }
    
    func getScanSettings() -> IScanSettings {
        scanSettingsDataHelper.read()
    }
    
    init(dataHelper: IScanSettingsDataHelper) {
        self.scanSettingsDataHelper = dataHelper
        self.initialSettings = scanSettingsDataHelper.read()
    }
    
    deinit {
        print("ScanSettingsRepository.deinit")
    }
    
}
