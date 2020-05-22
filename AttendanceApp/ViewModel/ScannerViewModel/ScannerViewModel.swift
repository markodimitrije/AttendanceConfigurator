//
//  ScannerViewModel.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 23/10/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension ScannerViewModel: IScannerViewModel {
    func getScannerInfoDriver() -> SharedSequence<DriverSharingStrategy, IScannerInfo> {
        createOutput(scanSettingsRepo: scanSettingsRepo)
    }
    
    func getActualBlockId() -> Int {
        self.blockId
    }
    
    func scannedCode(code: String, accepted: Bool) {
        guard let campaignId = campaignSelectionRepo.getSelected()?.getCampaignId() else {
            fatalError("cant scan if campaign not selected")
        }
        let report = CodeReportFactory.make(code: code, campaignId: campaignId, blockId: self.blockId, date: Date.now, accepted: accepted)
        codeReportsState.codeReport.onNext(report)
    }
    
}

class ScannerViewModel {
    
    private var scanSettingsRepo: IScanSettingsRepository!
    private let scannerInfoFactory: IScannerInfoFactory
    private let codeReportsState: CodeReportsState
    private let alertErrPresenter: IAlertErrorPresenter
    private let resourceState: IResourcesState = CampaignResourcesStateFactory.make()
    private let resourcesRepo: IMutableCampaignResourcesRepository
    private let campaignSelectionRepo = CampaignSelectionRepositoryFactory.make()
    let autoSessionTimer: AutoSessionTimer!
    
    init(scanSettingsRepo: IScanSettingsRepository,
         scannerInfoFactory: IScannerInfoFactory,
         codeReportsState: CodeReportsState,
         resourcesRepo: IMutableCampaignResourcesRepository,
         alertErrPresenter: IAlertErrorPresenter) {
        
        self.scanSettingsRepo = scanSettingsRepo
        self.scannerInfoFactory = scannerInfoFactory
        self.codeReportsState = codeReportsState
        self.resourcesRepo = resourcesRepo
        self.alertErrPresenter = alertErrPresenter
        
        self.autoSessionTimer =
            AutoSessionTimer(campaignSelectionRepo: CampaignSelectionRepositoryFactory.make(),
                             scanSettingsRepo: scanSettingsRepo)
        
        // TODO marko: bad design..
        let campaignId = campaignSelectionRepo.getSelected()!.getCampaignId()
        self.scanSettingsRepo.campaignSelected(campaignId: campaignId)
        
        handleCampaignResources()
    }
    
    // OUTPUT
    
    private var _oBlockId = BehaviorRelay<Int>.init(value: -1) // err state
    var blockId: Int {return _oBlockId.value}
    
    fileprivate let bag = DisposeBag()
    
    private func createOutput(scanSettingsRepo: IScanSettingsRepository)
        -> SharedSequence<DriverSharingStrategy, IScannerInfo> {
        
            let resourcesReady =
                resourceState.oResourcesDownloaded
                    .filter {$0 == true}
                    .map {_ in scanSettingsRepo.dbCampSettings}
            let obsSettings = scanSettingsRepo.obsDBCampSettings.share(replay: 1)
            
            let campaignSettings = Observable.merge([obsSettings, resourcesReady])
            
            return campaignSettings
                .map { (settings) -> IScannerInfo in
                    self.scannerInfoFactory.make(roomId: settings.roomId,
                                                 blockId: settings.blockId)
                }.do(onNext: { scannerInfo in
                    self._oBlockId.accept(scannerInfo.getBlockId())
                })
                .asDriver(onErrorJustReturn: ScannerInfo())
    }
    
    private func handleCampaignResources() {
        resourceState.oResourcesDownloaded
            .subscribe(onNext: { [weak self] (success) in
                if success {
                    print("all good..")
                } else {
                    self?.alertErrPresenter.present(error: CampaignResourcesError.badData)
                }
            })
            .disposed(by: bag)
    }
    
    deinit {
        autoSessionTimer.stopTimer()
        resourceState.stopTimer()
        resourcesRepo.deleteResources()
    }
    
}
