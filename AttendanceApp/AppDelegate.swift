//
//  AppDelegate.swift
//  tryObservableWebApiAndRealm
//
//  Created by Marko Dimitrijevic on 19/10/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RealmSwift

let kScanditBarcodeScannerAppKey = "AUe8bIKBFoCzJJPPuiOofAM5I9owLyf0rlrGJZhQ4LInWPIVz3VonUBir7VPXdyz4h8215sLK5dVPPhCIEV6A99KUPVsfXzQfy3w9wxVlWfFRgpOaUdH+XZlMQCuAEm1Th4eu8oxKt/6x0pVplemi4IzgCa4NYURqj2bXsWKR5/PaCIcmCZIYqGj8N4DUxA853PeccM7SeMhuUnuchIjzEyCZF8BThoEEqVty7e+SVPD4jBLOBbKvn59J0Goxy3tXOqIEI+jSL5bMXSBG1AdcJrFiLE4iVTAlP9jxaTD8SxspGhbEZXdSXFFNsHfrWRZQ7usbZNQmFjcWxjGCJ9WHqMtEXxRkx5jFiDWX98ZI2cOzNAT2AgquF62Ey6cXYT0nXupoIEnCgCDPx2HeHCCjI2yAaWPwnl2PJF4iQxz8VZHzSQiaJjl0udHnL0rneb0H9lqMVHEXiemwrBIBseFsQ71bNh611ukEqDI3nIFtBEX8ZJ6jmxYqMWtBcD+0mLeE3PoUbcHyJwzjTOJx66QJdj/vIb0NsTc8e6nzsh5UrHXtbq9Wtuki6vldYx5t1JHOZOX0458xybrnfKxBzp7s3CSA3o3AD8RZfY3SWvxcrOsA7fo68bSz5FkMLnsu/FDplihfPRRJoWSDs80ySLmlau6leNkyLXK11CzOZ9O67U80vefk8BAXOVpFLK0NwSE+360G6Hq8gOhseXeCgSLAsIFvCRWcUtalnDF3t9cRK6wMeywBULSzk553ZWwjUDrvIlq7TO5SqM7hHZ9jLcijZyxzU6wOm5H9gNxfRbXgP4ZeDVTtM6sLQ=="

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var alertStateReporter: AlertStateReporter!
    private let autoSessionTimer =  AutoSessionTimer.init(dataAccess: DataAccess.shared)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        let config = Realm.Configuration(schemaVersion: 2)
        Realm.Configuration.defaultConfiguration = config
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        UIApplication.shared.isIdleTimerDisabled = true // stop the iOS screen sleeping
        
        if syncResourcesManager == nil {
            let confId = conferenceState.conferenceId!
            syncResourcesManager = SyncResourcesManagerFactory.make(confId: confId)
        }
        
        alertStateReporter = AlertStateReporterFactory.make()
        
        loadInitialScreen()
        
        return true
    }
    
    private func loadInitialScreen() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = InitialScreenFactory.make()
        window?.makeKeyAndVisible()
    }
}

class InitialScreenFactory {
    static func make() -> UINavigationController {
        let userState = UserStateRepository()
        let loginVC = LoginViewControllerFactory.make()
        let rootVC = UINavigationController(rootViewController: loginVC)
        if userState.getToken().token == "" {
            return rootVC
        } else {
            let campaignsVC = CampaignsViewControllerFactory.make()
            rootVC.pushViewController(campaignsVC, animated: false)
            return rootVC
        }
    }
}
