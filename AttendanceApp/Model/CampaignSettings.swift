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

typealias CampaignSettingsSelection = (roomId: Int?, blockId: Int?, selectedDate: Date?, autoSwitch: Bool)

protocol ICampaignSettingsRepository {
    func campaignSelected(campaignId: String)
    var userSelection: (roomId: Int?, blockId: Int?, selectedDate: Date?, autoSwitch: Bool) {get}
    var output: Observable<(Int?, Int?, Date?, Bool)> {get}
    func deleteActualCampaignSettings()
    func deleteAllCampaignsSettings()
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
    
    private var campaignId: String = ""
    private var campaignIds = CampaignIds()
    
    func campaignSelected(campaignId: String) {
        self.campaignId = campaignId
        let settings = UserDefaults.standard.value(forKey: "campaignId" + campaignId) as? [String: Any]
        postUpdateOnOutput(settings: settings)
    }
    
    // API: input, output
    var userSelection: CampaignSettingsSelection {
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
            campaignIds.add(campaignId: campaignId)
            
            postUpdateOnOutput(userSelection: newValue)
        }
    }
    
    private func postUpdateOnOutput(userSelection: CampaignSettingsSelection) {
        _roomSelected.accept(userSelection.0)
        _blockSelected.accept(userSelection.1)
        _dateSelected.accept(userSelection.2)
        _autoSwitchSelected.accept(userSelection.3)
    }
    private func postUpdateOnOutput(settings: [String: Any]?) {
        _roomSelected.accept(settings?["roomId"] as? Int)
        _blockSelected.accept(settings?["blockId"] as? Int)
        _dateSelected.accept(settings?["date"] as? Date)
        _autoSwitchSelected.accept(settings?["autoSwitch"] as? Bool ?? true)
    }
    
    func deleteActualCampaignSettings() {
        UserDefaults.standard.set(nil, forKey: "campaignId" + campaignId)
        campaignIds.remove(campaignId: campaignId)
        _roomSelected.accept(nil)
        _blockSelected.accept(nil)
        _dateSelected.accept(nil)
        _autoSwitchSelected.accept(false)
    }
    
    func deleteAllCampaignsSettings() {
        campaignIds.removeAll()
        
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

struct CampaignIds {
    func add(campaignId: String) {
        let arr = UserDefaults.standard.array(forKey: "campaignIds") as? [String] ?? [String]()
        var updated = arr
        updated.append(campaignId)
        UserDefaults.standard.set(updated, forKey: "campaignIds")
    }
    func remove(campaignId: String) {
        let arr = UserDefaults.standard.array(forKey: "campaignIds") as? [String] ?? [String]()
        var updated = arr
        updated.removeAll(where: {$0 == campaignId})
        UserDefaults.standard.set(updated, forKey: "campaignIds")
    }
    func removeAll() {
        let arr = UserDefaults.standard.array(forKey: "campaignIds") as? [String] ?? [String]()
        _ = arr.map { (campaignId) in
            UserDefaults.standard.set(nil, forKey: "campaignId" + campaignId)
            remove(campaignId: campaignId)
        }
    }
}
