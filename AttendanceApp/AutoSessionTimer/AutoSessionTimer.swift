//
//  AutoSessionTimer.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 03/05/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AutoSessionTimer {
    private var scanSettingsRepo: IScanSettingsRepository
    private let campaignSelectionRepo: ICampaignSelectionRepository
    private var timer: Timer!
    init(campaignSelectionRepo: ICampaignSelectionRepository,
         scanSettingsRepo: IScanSettingsRepository) {
        
        self.campaignSelectionRepo = campaignSelectionRepo
        self.scanSettingsRepo = scanSettingsRepo
    
        loadTimer()
        
        NotificationCenter.default.addObserver(self,
                                       selector: #selector(appMovedToBackground),
                                       name: UIApplication.didEnterBackgroundNotification,
                                       object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
    
    @objc func fire() {
        print("AutoSessionTimer/fire, check for auto session = \(Date.now)")
        guard self.campaignSelectionRepo.getSelected() != nil else {
            return
        }
        let actualSettings = scanSettingsRepo.getScanSettings()
        if actualSettings.roomId != nil && actualSettings.autoSwitch { //print("dozvoljeno je da emitujes BLOCK")
            let blockViewModel = BlockViewModelFactory.make(roomId: actualSettings.roomId!,
                                                            date: actualSettings.selectedDate)
                
            blockViewModel.oAutomaticBlock.subscribe(onNext: { [weak self] block in
                guard let sSelf = self, let blockId = block?.getId() else {return}
                sSelf.scanSettingsRepo.update(blockId: blockId)
            }).disposed(by: disposeBag)
        }
    }
    
    @objc func appMovedToBackground() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    @objc func appWillEnterForeground() {
        loadTimer()
        fire()
    }
    
    private func loadTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: MyTimeInterval.autoSessionCheckEvery, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
        }
    }
    
    // API:
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private let disposeBag = DisposeBag()
    
    deinit {
        print("auto timer deinitialized!!")
    }
    
}
