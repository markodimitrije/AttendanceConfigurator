//
//  ScannerViewModelFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 04/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class ScannerViewModelFactory {
    static func make() -> ScannerViewModel {
        let blockRepo = BlockImmutableRepositoryFactory.make()
        let scannerInfoFactory = ScannerInfoFactory(roomRepo: RoomRepository(), blockRepo: blockRepo, blockPresenter: BlockPresenter())
        let codeReportsState = CodeReportsStateFactory.make()
        let resourcesRepo = MutableCampaignResourcesRepositoryFactory.make()
        let campaignSettings = CampaignSettingsRepositoryFactory.make()
        return ScannerViewModel(dataAccess: campaignSettings,
                                scannerInfoFactory: scannerInfoFactory,
                                codeReportsState: codeReportsState,
                                resourcesRepo: resourcesRepo,
                                alertErrPresenter: AlertErrorPresenter())
    }
}
