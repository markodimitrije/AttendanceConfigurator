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
    
    static let roomRepo = RoomRepository()
    static let blockRepo = BlockImmutableRepository()
    
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
            let date = InitialDateFactory().getDate()
            return BehaviorRelay<Date?>.init(value: date)
        }()
        settingsVC.roomSelected = {
            let room = InitialRoomFactory().getRoom()
            return BehaviorSubject<Int?>.init(value: room)
        }()
        settingsVC.blockManuallySelected = {
            let blockId = InitialBlockFactory().getBlock()
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


class InitialRoomFactory {
    let settings = ScanSettingsRepositoryFactory.make()
    let roomRepo = RoomRepository()
    func getRoom() -> Int? {
        let savedRoomId = settings.getScanSettings().roomId
        var room: Int?
        if let roomId = savedRoomId {
            room = roomRepo.getRoom(id: roomId)?.getId()
        } else {
            let rooms = roomRepo.getAllRooms()
            if rooms.count == 1 {
                room = rooms.first!.getId()
            }
        }
        return room
    }
}

class InitialDateFactory {
    let settings = ScanSettingsRepositoryFactory.make()
    let blockRepo = BlockImmutableRepository()
    func getDate() -> Date? {
        let savedDate = settings.getScanSettings().selectedDate
        var date: Date?
        if savedDate != nil {
            date = savedDate
        } else {
            let dates = blockRepo.getAvailableDates(roomId: settings.getScanSettings().roomId)
            date = (dates.count == 1) ? dates.first : nil
        }
        return date
    }
}

class InitialBlockFactory {
    let settings = ScanSettingsRepositoryFactory.make().getScanSettings()
    let blockRepo = BlockImmutableRepository()
    let initialRoomFactory = InitialRoomFactory()
    let initialDateFactory = InitialDateFactory()
    func getBlock() -> Int? {
        let savedBlock = settings.blockId
        var block: Int?
        if savedBlock != nil {
            block = savedBlock
        } else if let roomId = initialRoomFactory.getRoom() {
            let autoBlockViewModel =
                AutoBlockViewModelFactory.make(roomId: roomId, date: initialDateFactory.getDate())
            if let blockId = try? autoBlockViewModel.selectedBlock.value()?.getId() {
                block = blockId
            } else {
                block = nil
            }
        }
        return block
    }
}
