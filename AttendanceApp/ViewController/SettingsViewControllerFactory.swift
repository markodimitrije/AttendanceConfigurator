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
        let campaignSettings = ScanSettingsRepositoryFactory.make()

        attachExternalInputSignals(from: campaignSettings, toSettingsVC: settingsVC)
        attachOutputSignal(from: campaignSettings, toSettingsVC: settingsVC)
        
        return settingsVC
    }
    
    private static func attachExternalInputSignals(from settings: IScanSettingsImmutableRepository,
                                                   toSettingsVC settingsVC: SettingsViewController) {
        
        settingsVC.dateSelected = {
            let date = settings.dbCampSettings.selectedDate
            return BehaviorRelay<Date?>.init(value: date)
        }()
        settingsVC.roomSelected = {
            let roomId = settings.dbCampSettings.roomId
            return BehaviorSubject<Int?>.init(value: roomId)
        }()
        settingsVC.blockManuallySelected = {
            let blockId = settings.dbCampSettings.blockId
            return BehaviorSubject<Int?>.init(value: blockId)
        }()
    }
    
    private static func attachOutputSignal(from settings: IScanSettingsImmutableRepository,
                                           toSettingsVC settingsVC: SettingsViewController) {
        settingsVC.blockSelected = {
            let blockId = settings.dbCampSettings.blockId
            return BehaviorSubject<Int?>.init(value: blockId)
        }()
    }
}


