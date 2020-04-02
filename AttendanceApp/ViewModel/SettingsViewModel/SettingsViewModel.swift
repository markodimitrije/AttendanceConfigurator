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
    
    private let dataAccess: DataAccess
    private let roomRepo: IRoomRepository
    private let blockRepo: IBlockRepository
    
    private let initialRoom: Int?
    private let initialBlock: Int?
    private let initialDate: Date?
    private let initialAutoSwitch: Bool
    
    init(dataAccess: DataAccess, roomRepo: IRoomRepository, blockRepo: IBlockRepository) {
        self.dataAccess = dataAccess
        self.roomRepo = roomRepo
        self.blockRepo = blockRepo
        // set initial selection
        self.initialRoom = self.dataAccess.userSelection.roomId
        self.initialBlock = self.dataAccess.userSelection.blockId
        self.initialDate = self.dataAccess.userSelection.selectedDate
        self.initialAutoSwitch = self.dataAccess.userSelection.autoSwitch
    }
    
    func transform(input: Input) -> Output {
        
        let roomTxt = input.roomSelected.map { roomId -> String in
            guard let roomId = roomId else {
                return RoomTextData.selectRoom
            }
            return self.roomRepo.getRoom(id: roomId)?.getName() ?? ""
        }
        
        let interval = MyTimeInterval.waitToMostRecentSession
        let autoSessionDriver =
            Driver.combineLatest(input.roomSelected, input.sessionSwitch) {
                (roomId, switchIsOn) -> Int? in
            guard let roomId = roomId else { return nil }
            if switchIsOn {
                let autoModelView = AutoSelSessionWithWaitIntervalViewModel.init(roomId: roomId)
                autoModelView.inSelTimeInterval.onNext(interval)
                return try! autoModelView.selectedSession.value()?.id ?? nil // pazi ovde !! try !
            }
            return nil
        }.skip(1)
        
        let manualAndAutoSession = Driver.merge([input.sessionSelected, autoSessionDriver]).debug()
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
        let finalSession = Driver.combineLatest(manualAndAutoSession, saveCancelTrig).map {
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
        
        let sessionInfo = Driver.combineLatest(finalRoom,
                                               finalSession,
                                               finalDateSelected,
                                               finalAutoSwitch) {

            (roomId, blockId, date, autoSwitch) -> (Int, Int)? in

            self.dataAccess.userSelection = (roomId, blockId, date, autoSwitch) // MUST !

            guard let roomId = roomId, let sessionId = blockId else { return nil}

            return (roomId, sessionId)
        }
        
        let finalSessionId = finalSession.map { id -> Block? in
            guard let id = id else {return nil}
            return self.blockRepo.getBlock(id: id) as? Block // TODO marko: IBlock?
        }
        
        let dateTxt = input.dateSelected.map { date -> String in
            guard let date = date else { return "Select date" }
            return date.toString(format: "yyyy-MM-dd") ?? "error converting to date"
        }
        
        return Output(roomTxt: roomTxt,
                      dateTxt: dateTxt,
                      sessionTxt: sessionTxt,
                      saveSettingsAllowed: saveSettingsAllowed,
                      selectedBlock: /*finalSessionId,*/finalSession,
                      compositeSwitch: finalAutoSwitch,
                      sessionInfo: sessionInfo)
    }
}
