//
//  AppDelegate.swift
//  tryObservableWebApiAndRealm
//
//  Created by Marko Dimitrijevic on 19/10/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RealmSwift

let kScanditBarcodeScannerAppKey = "AWqOsbSBIC9+CX7jZAzG2Hs+u0OvKR923XNlJiNH6yc4WL26sFVHY9JJ7Y4Vfd6CKHtCdfkKUkyvXjbBrHr8/plpuhK3VwdVB2u4J+JxO8I7Yt5FgCRvnJttDPMaIZDU6ETfIy40DrXgCUByujG6ah/L9j84FOP/Q8jvZqzryDw8AorR0/2MHi34ZXDVQo2TV0uHK1kTQPeI2hy0XE2nXjjMpe4HycfvVsv/vJlzvF6Y93GHoCwLAIkSvG4RPp+1Wxa37jm6jvOLO/OKXEnTkSD589pd8Glh4ukQUvD2gDekaWT1ziReJnRcC1lgp6hWbvw+tWiRnCD/sZq9chjfUicBVSBHKxNU/srAt2C5pgzxE6OsnXyz/4nNTPhahE8oyWVbIL2uSefHtdgSUX9GVbKiOxMvbfYM9F2RIdrqDONXd0nY0OkjfSSgWlvKV/MTo/zAKSoTzSu4i6/uKeqTn171p3z64n+gSazfLKBnNfOlzZcN02Et1R8sGTJnSHt9fpRYmZG8IDSCQJpaOtpO3fxJw5brmsvFz8Bnntjx7tfRUd86+b9GM5Yt6tADCYlcjYi23SNA4aN+mRghoMgQuzCyxKrm3pI4IsVoXvY20mNaFAeaZUn0ech23qn7AFIVRfuYcz8yvbYALQ+5ZyrUXriikFfRFjeK8KUsN0HcI/oKNGLF5Ce5wIChbuwUcNQvPUplo+gNsskjAQcW5KMXAq7D7PS8FHScu+o9ULEdaW0Er5NgUSbNezwkP7W6hh2Ry0M4JnLz+uc1u0d7ZDijput4Hvmf+U1cITCrC/Ce9Rj5l6/9lRQ01krk19kgsNk="

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var alertStateReporter: AlertStateReporter!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        let config = Realm.Configuration(schemaVersion: 1)
        Realm.Configuration.defaultConfiguration = config
        
        print("Realm url: \(Realm.Configuration.defaultConfiguration.fileURL!)")
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        UIApplication.shared.isIdleTimerDisabled = true // stop the iOS screen sleeping
        
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
