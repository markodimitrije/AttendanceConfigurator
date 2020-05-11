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
    static func make() -> SettingsViewController {
        
        let settingsVC = StoryboardedViewControllerFactory.make(type: SettingsViewController.self) as! SettingsViewController
        settingsVC.settingsViewModel = SettingsViewModelFactory.make()

        attachExternalInputSignals(toSettingsVC: settingsVC)
        attachOutputSignal(toSettingsVC: settingsVC)
        
        return settingsVC
    }
    
    private static func attachExternalInputSignals(toSettingsVC settingsVC: SettingsViewController) {
        settingsVC.dateSelected = {
            let date = DataAccess.shared.userSelection.selectedDate
            return BehaviorRelay<Date?>.init(value: date)
        }()
        settingsVC.roomSelected = {
            let roomId = DataAccess.shared.userSelection.roomId
            return BehaviorSubject<Int?>.init(value: roomId)
        }()
        settingsVC.blockManuallySelected = {
            let blockId = DataAccess.shared.userSelection.blockId
            return BehaviorSubject<Int?>.init(value: blockId)
        }()
    }
    
    private static func attachOutputSignal(toSettingsVC settingsVC: SettingsViewController) {
        settingsVC.blockSelected = {
            let blockId = DataAccess.shared.userSelection.blockId
            return BehaviorSubject<Int?>.init(value: blockId)
        }()
    }
}


