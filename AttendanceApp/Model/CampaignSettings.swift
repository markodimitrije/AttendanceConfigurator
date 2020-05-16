//
//  CampaignSettingsRepository.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 04/12/2018.
//  Copyright © 2018 Navus. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

protocol ICampaignSettingsRepository {
    var userSelection: (roomId: Int?, blockId: Int?, selectedDate: Date?, autoSwitch: Bool) {get}
    var output: Observable<(Int?, Int?, Date?, Bool)> {get}
}

class CampaignSettingsRepository: NSObject, ICampaignSettingsRepository {
    
    lazy private var _roomSelected = BehaviorRelay<Int?>.init(value: roomInitial)
    lazy private var _blockSelected = BehaviorRelay<Int?>.init(value: blockInitial)
    lazy private var _dateSelected = BehaviorRelay<Date?>.init(value: dateInitial)
    lazy private var _autoSwitchSelected = BehaviorRelay<Bool>.init(value: autoSwitchInitial)
    
    private var roomInitial: Int?
    private var blockInitial: Int?
    private var dateInitial: Date?
    private var autoSwitchInitial: Bool
    
    static var shared = CampaignSettingsRepository()
    private var campaignId: String {
        CampaignSelectionRepositoryFactory.make().getSelected()!.getCampaignId()
    }
    
    // API: input, output
    var userSelection: (roomId: Int?, blockId: Int?, selectedDate: Date?, autoSwitch: Bool) {
        get {
            let settings = UserDefaults.standard.value(forKey: "campaignId" + campaignId) as? [String: Any]
            return (settings?["roomId"] as? Int,
                    settings?["blockId"] as? Int,
                    settings?["date"] as? Date,
                    settings?["autoSwitch"] as? Bool ?? true)
        }
        set {
            var settings = [String : Any]()
            if newValue.0 != nil { settings["roomId"] = newValue.0 }
            if newValue.1 != nil { settings["blockId"] = newValue.1 }
            if newValue.2 != nil { settings["date"] = newValue.2 }
            settings["autoSwitch"] = newValue.3
            
            UserDefaults.standard.set(settings, forKey: "campaignId" + campaignId)
            _roomSelected.accept(newValue.0)
            _blockSelected.accept(newValue.1)
            _dateSelected.accept(newValue.2)
            _autoSwitchSelected.accept(newValue.3)
        }
    }
    
    func deleteCampaignSettings() {
        UserDefaults.standard.set(nil, forKey: "campaignId" + campaignId)
        _roomSelected.accept(nil)
        _blockSelected.accept(nil)
        _dateSelected.accept(nil)
        _autoSwitchSelected.accept(false)
    }
    
    // API: output
    var output: Observable<(Int?, Int?, Date?, Bool)> {
        return Observable.combineLatest(_roomSelected.asObservable(),
                                        _blockSelected.asObservable(),
                                        _dateSelected.asObservable(),
                                        _autoSwitchSelected.asObservable(),
            resultSelector: { (room, block, date, autoSwitch) -> (Int?, Int?, Date?, Bool) in
            return (room, block, date, autoSwitch)
        })
    }
    
    override init() {
        if let campaignId = CampaignSelectionRepositoryFactory.make().getSelected()?.getCampaignId() {
            let settings = UserDefaults.standard.value(forKey: "campaignId" + campaignId) as? [String: Any]
            self.roomInitial = settings?["roomId"] as? Int
            self.blockInitial = settings?["blockId"] as? Int
            self.dateInitial = settings?["date"] as? Date
            self.autoSwitchInitial = settings?["autoSwitch"] as? Bool ?? true
        } else {
            self.roomInitial = nil
            self.blockInitial = nil
            self.dateInitial = nil
            self.autoSwitchInitial = true
        }
        super.init()
    }
    
    deinit {
        print("CampaignSettingsRepository.deinit")
    }
    
}
