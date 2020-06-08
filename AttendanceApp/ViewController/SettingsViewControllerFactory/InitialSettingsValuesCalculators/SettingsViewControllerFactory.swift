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
        settingsVC.scanSettingsRepo = ScanSettingsRepositoryFactory.make()
        let campaignSettings = ScanSettingsRepositoryFactory.make()
        
        let settingsInitials =
            InitialSettingsValuesCalculator(roomCalculator: InitialRoomCalculatorFactory.make(),
                                  blockCalculator: InitialBlockCalculatorFactory.make(),
                                  dateCalculator: InitialDateCalculatorFactory.make())

        attachExternalInputSignals(from: campaignSettings,
                                   toSettingsVC: settingsVC,
                                   settingsInitials: settingsInitials)
        attachOutputSignal(from: campaignSettings, toSettingsVC: settingsVC)
        
        return settingsVC
    }
    
    private static func attachExternalInputSignals(from settings: IScanSettingsImmutableRepository,
                                                   toSettingsVC settingsVC: SettingsViewController,
                                                   settingsInitials: InitialSettingsValuesCalculator) {
        
        settingsVC.dateSelected = {
            let date = settingsInitials.dateCalculator.getDate()
            return BehaviorRelay<Date?>.init(value: date)
        }()
        settingsVC.roomSelected = {
            let room = settingsInitials.roomCalculator.getRoom()
            return BehaviorSubject<Int?>.init(value: room)
        }()
        settingsVC.blockManuallySelected = {
            let blockId = settingsInitials.blockCalculator.getBlock()
            return BehaviorSubject<Int?>.init(value: blockId)
        }()
    }
    
    private static func attachOutputSignal(from settings: IScanSettingsImmutableRepository,
                                           toSettingsVC settingsVC: SettingsViewController) {
        settingsVC.blockSelected = {
            let blockId = settings.getScanSettings().blockId
            return BehaviorSubject<Int?>.init(value: blockId)
        }()
    }
}
