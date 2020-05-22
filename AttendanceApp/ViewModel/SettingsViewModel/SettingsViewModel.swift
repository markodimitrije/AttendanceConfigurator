//
//  File.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 22/11/2018.
//  Copyright © 2018 Navus. All rights reserved.
//

import RxSwift
import RxCocoa

final class SettingsViewModel: ViewModelType {
    
    private var scanSettingsRepo: IScanSettingsRepository
    private let roomRepo: IRoomRepository
    private let blockRepo: IBlockImmutableRepository
    private let deviceStateReporter: DeviceStateReporter
    
    private let initialRoom: Int?
    private let initialBlock: Int?
    private let initialDate: Date?
    private let initialAutoSwitch: Bool
    
    init(scanSettingsRepo: IScanSettingsRepository, roomRepo: IRoomRepository, blockRepo: IBlockImmutableRepository, deviceStateReporter: DeviceStateReporter) {
        self.scanSettingsRepo = scanSettingsRepo
        self.roomRepo = roomRepo
        self.blockRepo = blockRepo
        self.deviceStateReporter = deviceStateReporter
        // set initial selection
        self.initialRoom = self.scanSettingsRepo.userSelection.roomId
        self.initialBlock = self.scanSettingsRepo.userSelection.blockId
        self.initialDate = self.scanSettingsRepo.userSelection.selectedDate
        self.initialAutoSwitch = self.scanSettingsRepo.userSelection.autoSwitch
    }
    
    func transform(input: Input) -> Output {
        
        let roomTxt = input.roomSelected.map { roomId -> String in
            guard let roomId = roomId else {
                return RoomTextData.selectRoom
            }
            return self.roomRepo.getRoom(id: roomId)?.getName() ?? ""
        }
        
        let autoSessionDriver =
            Driver.combineLatest(input.dateSelected, input.roomSelected, input.sessionSwitch) {
                (date, roomId, switchIsOn) -> Int? in
            guard let roomId = roomId else { return nil }
            if switchIsOn {
                
                let autoModelView = AutoBlockViewModelFactory.make(roomId: roomId, date: date)
                return try! autoModelView.selectedBlock.value()?.getId() ?? nil // pazi ovde !! try !
            }
            return nil
        }.skip(1)
        
        let manualAndAutoSession = Driver.merge([input.sessionSelected, autoSessionDriver])//.debug()
        let a = input.roomSelected.map { _ -> Void in return () }
        let b = input.sessionSelected.map { _ -> Void in return () }
        let c = autoSessionDriver.map { _ -> Void in return () }
        
        let composeAllEvents = Driver.merge([a,b,c])

        let saveSettingsAllowed = composeAllEvents.withLatestFrom(manualAndAutoSession)
            .map { block -> Bool in
                return block != nil
            }
        
        let sessionTxt =
            Driver.combineLatest(manualAndAutoSession, input.sessionSwitch) {
            (blockId, state) -> String in
                if let blockId = blockId,
                    let blockName = self.blockRepo.getBlock(id: blockId)?.getName() {
                        return blockName
                } else {
                    if state {
                        return SessionTextData.noAutoSessAvailable
                    } else {
                        return SessionTextData.selectSessionManually
                    }
                }
        }
        
        let saveCancelTrig = Driver.merge([input.cancelTrigger.map {return false},
                                           input.saveSettingsTrigger.map {return true}])
        
        //roomDriver
        let finalRoom = Driver.combineLatest(input.roomSelected, saveCancelTrig).map {
            $1 ? $0 : self.initialRoom
        }
        
        //sessionDriver
        let finalBlock = Driver.combineLatest(manualAndAutoSession, saveCancelTrig).map {
            $1 ? $0 : self.initialBlock
        }
        
        //autoSwitchDriver
        let compositeSwitch: Driver<Bool> =
        Driver.merge(input.blockSelectedManually.map {_ in return false},
                                                     input.sessionSwitch)//.debug()
        
        let finalAutoSwitch = Driver.combineLatest(compositeSwitch, saveCancelTrig).map {
            $1 ? $0 : self.initialAutoSwitch
        }
        
        let finalDateSelected = Driver.combineLatest(manualAndAutoSession, saveCancelTrig)
            .map { (arg) -> Date? in
                let blockId: Int? = arg.0
                let tap: Bool = arg.1
                let block = self.blockRepo.getBlock(id: blockId ?? -1)
                return (tap) ? block?.getStartsAt() : self.initialDate
        }
        
        let sessionInfo =
            Driver.combineLatest(finalRoom, finalBlock, finalDateSelected, finalAutoSwitch) {

            (roomId, blockId, date, autoSwitch) -> (Int, Int)? in

            self.scanSettingsRepo.userSelection = CampaignSettings(roomId: roomId, blockId: blockId, selDate: date, autoSwitch: autoSwitch) // MUST !

            guard let roomId = roomId, let blockId = blockId else { return nil}
                                                
            self.sendDeviceReport(info: (roomId, blockId))
                                                
            return (roomId, blockId)
        }
        
        let dateTxt = input.dateSelected.map { date -> String in
            guard let date = date else { return "Select date" }
            return date.toString(format: "yyyy-MM-dd") ?? "error converting to date"
        }
        
        return Output(roomTxt: roomTxt,
                      dateTxt: dateTxt,
                      sessionTxt: sessionTxt,
                      saveSettingsAllowed: saveSettingsAllowed,
                      selectedBlock: finalBlock,
                      compositeSwitch: finalAutoSwitch,
                      sessionInfo: sessionInfo)
    }
    
    private func sendDeviceReport(info: (Int, Int)) {
        let batInfo = BatteryManager.init().info
        deviceStateReporter.blockIsSet(info: info, battery_info: batInfo, app_active: true)
    }
}
