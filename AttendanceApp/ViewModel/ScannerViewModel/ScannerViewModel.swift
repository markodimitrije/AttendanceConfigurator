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
        createOutput(dataAccess: dataAccess)
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
    
    private var dataAccess: CampaignSettingsRepository!
    private let scannerInfoFactory: IScannerInfoFactory
    private let codeReportsState: CodeReportsState
    private let alertErrPresenter: IAlertErrorPresenter
    private let resourceState: IResourcesState = CampaignResourcesStateFactory.make()
    private let campaignSelectionRepo = CampaignSelectionRepositoryFactory.make()
    let autoSessionTimer =
    AutoSessionTimer(campaignSelectionRepo: CampaignSelectionRepositoryFactory.make(),
                     dataAccess: CampaignSettingsRepository.shared)
    
    init(dataAccess: CampaignSettingsRepository,
         scannerInfoFactory: IScannerInfoFactory,
         codeReportsState: CodeReportsState,
         alertErrPresenter: IAlertErrorPresenter) {
        
        self.dataAccess = dataAccess
        self.scannerInfoFactory = scannerInfoFactory
        self.codeReportsState = codeReportsState
        self.alertErrPresenter = alertErrPresenter
        
        // TODO marko: bad design..
        let campaignId = campaignSelectionRepo.getSelected()!.getCampaignId()
        self.dataAccess.campaignSelected(campaignId: campaignId)
        
        handleCampaignResources()
    }
    
    // OUTPUT
    
    private var _oBlockId = BehaviorRelay<Int>.init(value: -1) // err state
    var blockId: Int {return _oBlockId.value}
    
    fileprivate let bag = DisposeBag()
    
    private func createOutput(dataAccess: CampaignSettingsRepository)
        -> SharedSequence<DriverSharingStrategy, IScannerInfo> {
        
        return dataAccess.output
            .delay(0.05, scheduler: MainScheduler.instance) // HACK - ovaj signal emituje pre nego je izgradjen UI
            .map { (roomId, blockId, _, _) -> IScannerInfo in
                return self.scannerInfoFactory.make(roomId: roomId, blockId: blockId)
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
        print("ScannerViewModel.deinit")
        resourceState.stopTimer()
    }
    
}
