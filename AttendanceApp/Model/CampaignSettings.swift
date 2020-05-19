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
    var userSelection: CampaignSettingsSelection {get}
    var output: Observable<(Int?, Int?, Date?, Bool)> {get}
    func deleteActualCampaignSettings()
    func deleteAllCampaignsSettings()
}

class CampaignSettingsRepository: NSObject, ICampaignSettingsRepository {
    
    lazy private var _roomSelected = BehaviorRelay<Int?>.init(value: initialSettings.roomId)
    lazy private var _blockSelected = BehaviorRelay<Int?>.init(value: initialSettings.blockId)
    lazy private var _dateSelected = BehaviorRelay<Date?>.init(value: initialSettings.selectedDate)
    lazy private var _autoSwitchSelected = BehaviorRelay<Bool>.init(value: initialSettings.autoSwitch)
    
    private var initialSettings: CampaignSettings
    
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
            CampaignSettingsUserDefaultsRepo.save(selection: newValue, campaignId: campaignId)
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
            self.initialSettings = CampaignSettings(settings: settings)
        } else {
            initialSettings = CampaignSettings()
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

protocol ICampaignSettings {
    var roomId: Int? {get}
    var blockId: Int? {get}
    var selectedDate: Date? {get}
    var autoSwitch: Bool {get}
}

struct CampaignSettings: ICampaignSettings {
    var roomId: Int?
    var blockId: Int?
    var selectedDate: Date?
    var autoSwitch: Bool
    init(roomId: Int? = nil, blockId: Int? = nil, selDate: Date? = nil, autoSwitch: Bool = true) {
        self.roomId = roomId
        self.blockId = blockId
        self.selectedDate = selDate
        self.autoSwitch = autoSwitch
    }
    init(settings: [String: Any]?) {
        self.roomId = settings?["roomId"] as? Int
        self.blockId = settings?["blockId"] as? Int
        self.selectedDate = settings?["date"] as? Date
        self.autoSwitch = settings?["autoSwitch"] as? Bool ?? true
    }
}

class CampaignSettingsUserDefaultsRepo {
    static func read(campaignId: String) -> ICampaignSettings {
        guard let settings = UserDefaults.standard.value(forKey: "campaignId" + campaignId) as? [String: Any] else {
            return CampaignSettings()
        }
        return CampaignSettings(roomId: settings["roomId"] as? Int,
                                blockId: settings["blockId"] as? Int,
                                selDate: settings["date"] as? Date,
                                autoSwitch: settings["autoSwitch"] as? Bool ?? true)
    }
    static func save(selection: CampaignSettingsSelection, campaignId: String) {
        var settings = [String : Any]()
        if selection.0 != nil { settings["roomId"] = selection.0 }
        if selection.1 != nil { settings["blockId"] = selection.1 }
        if selection.2 != nil { settings["date"] = selection.2 }
        settings["autoSwitch"] = selection.3
        UserDefaults.standard.set(settings, forKey: "campaignId" + campaignId)
    }
}




