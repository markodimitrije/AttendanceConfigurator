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
    
    private let bag = DisposeBag()
    
    private var scanSettingsRepo: IScanSettingsRepository
    private let roomRepo: IRoomRepository
    private let blockRepo: IBlockImmutableRepository
    
    private let initialSettings: IScanSettings
    
    init(scanSettingsRepo: IScanSettingsRepository, roomRepo: IRoomRepository, blockRepo: IBlockImmutableRepository) {
        self.scanSettingsRepo = scanSettingsRepo
        self.roomRepo = roomRepo
        self.blockRepo = blockRepo
        // set initial selection
        self.initialSettings = self.scanSettingsRepo.getScanSettings()
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
        
        //roomDriver
        let finalRoom = input.roomSelected
        //sessionDriver
        let finalBlock = manualAndAutoSession
        //autoSwitchDriver
        let finalAutoSwitch: Driver<Bool> =
        Driver.merge(input.blockSelectedManually.map {_ in return false},
                                                     input.sessionSwitch)//.debug()
        //dateDriver
        let finalDateSelected = manualAndAutoSession
            .map { (blockId) -> Date? in
                let block = self.blockRepo.getBlock(id: blockId ?? -1)
                return block?.getStartsAt()
        }
        
        let settings = Driver.combineLatest(finalRoom, finalBlock, finalDateSelected, finalAutoSwitch) { (room, block, date, autoswitch) in
            (room, block, date, autoswitch)
        }
        
        input.saveSettingsTrigger.withLatestFrom(settings)
            .asObservable()
            .subscribe(onNext: { [weak self] (roomId, blockId, date, autoSwitch) in
                guard let roomId = roomId, let blockId = blockId else {return}
                self?.onUserSavedSettings(roomId: roomId, blockId: blockId, date: date, autoSwitch: autoSwitch)
            }).disposed(by: bag)
        
        let dateTxt = input.dateSelected.map { date -> String in
            guard let date = date else { return "Select date" }
            return date.toString(format: "yyyy-MM-dd") ?? "error converting to date"
        }
        
        let finishTrigger = Driver.merge([input.saveSettingsTrigger, input.cancelTrigger])
        
        return Output(roomTxt: roomTxt,
                      sessionTxt: sessionTxt,
                      dateTxt: dateTxt,
                      compositeSwitch: finalAutoSwitch,
                      saveSettingsAllowed: saveSettingsAllowed,
                      finishTrigger: finishTrigger)
    }
    
    private func onUserSavedSettings(roomId: Int, blockId: Int, date: Date?, autoSwitch: Bool) {
        let settings = ScanSettings(roomId: roomId, blockId: blockId, selDate: date, autoSwitch: autoSwitch)
        self.persist(settings: settings)
    }
    
    private func persist(settings: IScanSettings) {
        self.scanSettingsRepo.update(settings: settings)
    }
    
}
