//
//  SettingsViewControllerFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 03/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SettingsViewControllerFactory {
    static func make() -> SettingsVC {
        let settingsVC = UIStoryboard.main.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        settingsVC.settingsViewModel = SettingsViewModelFactory.make()
        
        attachExternalInputSignals(toSettingsVC: settingsVC)
        attachOutputSignal(toSettingsVC: settingsVC)
        
        return settingsVC
    }
    
    private static func attachExternalInputSignals(toSettingsVC settingsVC: SettingsVC) {
        settingsVC.dateSelected = {
            let date = DataAccess.shared.userSelection.selectedDate
            return BehaviorRelay<Date?>.init(value: date)
        }()
        settingsVC.roomSelected = {
            let roomId = DataAccess.shared.userSelection.roomId
            return BehaviorSubject<Int?>.init(value: roomId)
        }()
        settingsVC.sessionManuallySelected = {
            let blockId = DataAccess.shared.userSelection.blockId
            return BehaviorSubject<Int?>.init(value: blockId)
        }()
    }
    
    private static func attachOutputSignal(toSettingsVC settingsVC: SettingsVC) {
        settingsVC.sessionSelected = {
            let blockId = DataAccess.shared.userSelection.blockId
            return BehaviorSubject<Int?>.init(value: blockId)
        }()
    }
}


