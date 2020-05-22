//
//  ScanSettingsDataHelper.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 19/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

protocol IScanSettingsDataHelper {
    func read() -> IScanSettings
    func save(selection: IScanSettings)
    func getObsActualSettings() -> Observable<IScanSettings>
    //TODO marko: delete
}

extension ScanSettingsDataHelper: IScanSettingsDataHelper {
    func read() -> IScanSettings {
        guard let campaignId = campaignId else {
            return ScanSettings()
        }
        let predicate = NSPredicate(format: "campaignId == %@", campaignId)
        let rSettings = try! genRepo.getObjects(ofType: RealmScanSettings.self,
                                                filter: predicate).first
        if rSettings != nil {
            return ScanSettingsFactory.make(rScanSettings: rSettings!)
        } else {
            return ScanSettings()
        }
    }
    func save(selection: IScanSettings) {
        let rSettings = ScanSettingsFactory.make(scanSettings: selection)
        rSettings.campaignId = campaignId!
        try! genRepo.save(objects: [rSettings])
    }
    func getObsActualSettings() -> Observable<IScanSettings> {
        let filter = NSPredicate(format: "campaignId == %@", self.campaignId!)
        return genRepo
            .getObsObjects(ofType: RealmScanSettings.self, filter: filter)
            .map({ (arr) -> IScanSettings in
                (arr.first != nil) ?
                    ScanSettingsFactory.make(rScanSettings: arr.first!) :
                    ScanSettings()
            })
    }
    
}

struct ScanSettingsDataHelper {
    let genRepo: IGenRepository
    let campSelectionRepo: ICampaignSelectionRepository
    var campaignId: String? {
        campSelectionRepo.getSelected()?.getCampaignId()
    }
}
