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
    
    private let initialSettings: IScanSettings
    private let scanSettingsDataHelper: IScanSettingsDataHelper
    private let deviceStateReporterDelegate: DeviceStateReporter
    
    // API: input, output
    
    func update(settings: IScanSettings) {
        scanSettingsDataHelper.save(selection: settings)
        sendDeviceReport()
    }
    func update(blockId: Int) {
        var settings = scanSettingsDataHelper.read()
        settings.blockId = blockId
        scanSettingsDataHelper.save(selection: settings)
        sendDeviceReport()
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

    private func sendDeviceReport() {
        let batInfo = BatteryManager.init().info
        let info = (getScanSettings().roomId!, getScanSettings().blockId!)
        deviceStateReporterDelegate.blockIsSet(info: info, battery_info: batInfo, app_active: true)
    }
    
    init(dataHelper: IScanSettingsDataHelper, deviceStateReporterDelegate: DeviceStateReporter) {
        self.scanSettingsDataHelper = dataHelper
        self.deviceStateReporterDelegate = deviceStateReporterDelegate
        self.initialSettings = scanSettingsDataHelper.read()
    }
    
    deinit {
//        print("ScanSettingsRepository.deinit")
    }
    
}
