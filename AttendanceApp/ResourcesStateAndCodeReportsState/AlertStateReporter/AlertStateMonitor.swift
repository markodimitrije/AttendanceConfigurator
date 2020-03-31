//
//  AlertStateMonitor.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 31/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AlertStateMonitor {
    
    // OUTPUT
    var deviceReport = DeviceReport.init()
    
    // MARK: - Private vars
    
    private var _batteryState: String {
        return batteryStateConverter[UIDevice.current.batteryState] ?? ""
    }
    
    init() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange(_:)), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(batteryStateDidChange(_:)), name: UIDevice.batteryStateDidChangeNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive(_:)), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func batteryLevelDidChange(_ notification: Notification) {
        print("AlertStateMonitor/batteryLevelDidChange = \(UIDevice.current.batteryLevel)")
        deviceReport.batteryLevel.accept(Int( 100 * UIDevice.current.batteryLevel ))
    }
    
    @objc func batteryStateDidChange(_ notification: Notification) {
        print("AlertStateMonitor/batteryStateDidChange = \(UIDevice.current.batteryState)")
        deviceReport.batteryState.accept(_batteryState)
    }
    
    @objc func didBecomeActive(_ notification: Notification) {
        print("AlertStateMonitor/appBecameActive is called")
        deviceReport.appInForeground.accept(true)
    }
    
    @objc func appWillResignActive(_ notification: Notification) {
        print("AlertStateMonitor/appWillResignActive is called")
        deviceReport.appInForeground.accept(false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIDevice.batteryStateDidChangeNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    struct DeviceReport {
        
        var batteryLevel: BehaviorRelay<Int>!
        var batteryState: BehaviorRelay<String>!
        var appInForeground: BehaviorRelay<Bool>!
        
        init() { // init-ujem sa actual vals + losiji scenario za appInForeground..
            //print("emitujem batLevel = \(Int(100*UIDevice.current.batteryLevel))")
            batteryLevel = BehaviorRelay<Int>.init(value: Int(100*UIDevice.current.batteryLevel))
            batteryState = BehaviorRelay<String>.init(value: batteryStateConverter[UIDevice.current.batteryState] ?? "")
            appInForeground = BehaviorRelay<Bool>.init(value: false)
        }
    }
}
