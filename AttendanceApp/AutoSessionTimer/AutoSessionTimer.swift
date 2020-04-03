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
    private var dataAccess: DataAccess
    private var timer: Timer!
    init(dataAccess: DataAccess) {
        
        self.dataAccess = dataAccess
    
        loadTimer()
        
        NotificationCenter.default.addObserver(self,
                                       selector: #selector(appMovedToBackground),
                                       name: UIApplication.willResignActiveNotification,
                                       object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
    
    @objc func fire() { //print("AutoSessionTimer/fire, check for auto session = \(NOW)")
        let actualSettings = dataAccess.userSelection
        if actualSettings.roomId != nil && actualSettings.autoSwitch { //print("dozvoljeno je da emitujes BLOCK")
            let blockViewModel = BlockViewModelFactory.make(roomId: actualSettings.roomId)
                //BlockViewModel.init(roomId: actualSettings.roomId)
            blockViewModel.oAutomaticSession.subscribe(onNext: { [weak self] block in
                guard let sSelf = self else {return}
                var updateData = sSelf.dataAccess.userSelection
                updateData.blockId = block?.id
                sSelf.dataAccess.userSelection = updateData
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
    }
    
    private func loadTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(fire), userInfo: nil, repeats: false)
            timer = Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
        }
    }
    
    private let disposeBag = DisposeBag()
    
    deinit {
        print("o-o, auto timer deinitialized!!")
    }
    
}
