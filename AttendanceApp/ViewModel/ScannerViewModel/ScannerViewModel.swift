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
    
    private var scanSettingsRepo: IScanSettingsImmutableRepository!
    private let scannerInfoFactory: IScannerInfoFactory
    private let codeReportsState: CodeReportsState
    private let alertErrPresenter: IAlertErrorPresenter
    private let resourceState: IResourcesState = CampaignResourcesStateFactory.make()
    private let resourcesRepo: IMutableCampaignResourcesRepository
    private let campaignSelectionRepo = CampaignSelectionRepositoryFactory.make()
    private let autoSessionTimer: AutoSessionTimer!
    weak var delegate: ScannerViewController?
    
    init(scanSettingsRepo: IScanSettingsImmutableRepository,
         scannerInfoFactory: IScannerInfoFactory,
         codeReportsState: CodeReportsState,
         resourcesRepo: IMutableCampaignResourcesRepository,
         alertErrPresenter: IAlertErrorPresenter,
         autoSessionTimer: AutoSessionTimer) {
        
        self.scanSettingsRepo = scanSettingsRepo
        self.scannerInfoFactory = scannerInfoFactory
        self.codeReportsState = codeReportsState
        self.resourcesRepo = resourcesRepo
        self.alertErrPresenter = alertErrPresenter
        self.autoSessionTimer = autoSessionTimer
                
        handleCampaignResources()
    }
    
    // OUTPUT
    
    private var _oBlockId = BehaviorRelay<Int>.init(value: -1) // err state
    var blockId: Int {return _oBlockId.value}
    
    fileprivate let bag = DisposeBag()
    
    private func createOutput(scanSettingsRepo: IScanSettingsImmutableRepository)
        -> SharedSequence<DriverSharingStrategy, IScannerInfo> {
        
            let resourcesReady =
                resourceState.oResourcesDownloaded
                    .filter {$0 == DownloadStatus.success}
                    .map {_ in scanSettingsRepo.getScanSettings()}
            let obsSettings = scanSettingsRepo.getObsScanSettings().share(replay: 1)
            
            let campaignSettings = Observable.merge([obsSettings, resourcesReady])
            
            return campaignSettings
            .debug()
                .map { (settings) -> IScannerInfo in
                    self.scannerInfoFactory.make(roomId: settings.roomId,
                                                 blockId: settings.blockId)
                }.do(onNext: { scannerInfo in
                    self._oBlockId.accept(scannerInfo.getBlockId())
                })
                .asDriver(onErrorJustReturn: ScannerInfo())
    }
    
    private func handleCampaignResources() {
        
        connectedToInternet().distinctUntilChanged().share(replay: 1)
            .subscribe(onNext: { [weak self] (success) in
                guard let sSelf = self else {return}
                if success {
                    delay(0.1) {
                        DispatchQueue.main.async { [weak self] in
                            self?.delegate?.activityIndicator.startAnimating()
                        }
                    }
                }
                
                sSelf.resourceState.oResourcesDownloaded
                    .subscribe(onNext: { [weak self] (status) in
                        switch status {
                            case .success:
                                print("all good..")
                            case .fail(let err):
                                self?.alertErrPresenter.present(error: err)
                        }
                        self?.delegate?.activityIndicator.stopAnimating()
                    })
                    .disposed(by: sSelf.bag)
            })
            .disposed(by: self.bag)
    }
    
    deinit {
        autoSessionTimer.stopTimer()
        resourceState.stopTimer()
        resourcesRepo.deleteResources()
    }
    
}
