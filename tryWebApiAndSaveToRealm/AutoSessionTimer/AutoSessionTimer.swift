//
//  AutoSessionTimer.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 03/05/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import UIKit

class AutoSessionTimer {
    private var dataAccess: DataAccess
    private var timer: Timer!
    init(dataAccess: DataAccess) {
        
        self.dataAccess = dataAccess
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
        }
        
        NotificationCenter.default.addObserver(self,
                                       selector: #selector(appMovedToBackground),
                                       name: UIApplication.willResignActiveNotification,
                                       object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        
    }
    
//    deinit {
//        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
//    }
    
    @objc func fire() {
        print("AutoSessionTimer/fire, check for auto session = \(NOW)")
    }
    
    @objc func appMovedToBackground() {
        print("AutoSessionTimer/appMovedToBackground!")
        timer.invalidate()
        timer = nil
    }
    
    @objc func appWillEnterForeground() {
        print("AutoSessionTimer/appWillEnterForeground")
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
    }
    
}
