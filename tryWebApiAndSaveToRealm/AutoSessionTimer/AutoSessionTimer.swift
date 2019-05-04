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
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
        }
        
        NotificationCenter.default.addObserver(self,
                                       selector: #selector(appMovedToBackground),
                                       name: UIApplication.willResignActiveNotification,
                                       object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        
        dataAccess.output
            .subscribe(onNext: { [weak self] (room, block, date, autoSwitch) in
                self?.fire()
            }).disposed(by: disposeBag)
    }
    
    @objc func fire() { // print("AutoSessionTimer/fire, check for auto session = \(NOW)")
        let actualSettings = dataAccess.userSelection
        if actualSettings.roomId != nil && actualSettings.autoSwitch { print("dozvoljeno je da emitujes BLOCK")
            let blockViewModel = BlockViewModel.init(roomId: actualSettings.roomId)
            blockViewModel.oAutomaticSession.subscribe(onNext: { [weak self] block in
                guard let sSelf = self else {return}
                var updateData = sSelf.dataAccess.userSelection
                updateData.blockId = block?.id
                sSelf.dataAccess.userSelection = updateData
            }).disposed(by: disposeBag)
        } else {
            print("ne smes da emitujes BLOCK, do nothing...")
        }
    }
    
    @objc func appMovedToBackground() {
        timer.invalidate()
        timer = nil
    }
    
    @objc func appWillEnterForeground() {
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
    }
    
    private let disposeBag = DisposeBag()
    
}
