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
        let campaignSettings = CampaignSettingsRepositoryFactory.make()

        attachExternalInputSignals(from: campaignSettings, toSettingsVC: settingsVC)
        attachOutputSignal(from: campaignSettings, toSettingsVC: settingsVC)
        
        return settingsVC
    }
    
    private static func attachExternalInputSignals(from settings: ICampaignSettingsRepository,
                                                   toSettingsVC settingsVC: SettingsViewController) {
        settingsVC.dateSelected = {
            let date = settings.userSelection.selectedDate
            return BehaviorRelay<Date?>.init(value: date)
        }()
        settingsVC.roomSelected = {
            let roomId = settings.userSelection.roomId
            return BehaviorSubject<Int?>.init(value: roomId)
        }()
        settingsVC.blockManuallySelected = {
            let blockId = settings.userSelection.blockId
            return BehaviorSubject<Int?>.init(value: blockId)
        }()
    }
    
    private static func attachOutputSignal(from settings: ICampaignSettingsRepository,
                                           toSettingsVC settingsVC: SettingsViewController) {
        settingsVC.blockSelected = {
            let blockId = settings.userSelection.blockId
            return BehaviorSubject<Int?>.init(value: blockId)
        }()
    }
}


