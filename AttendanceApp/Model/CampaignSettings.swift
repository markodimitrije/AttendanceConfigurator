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
    var userSelection: ICampaignSettings {get}
    var obsCampSettings: Observable<ICampaignSettings> {get}
    func campaignSelected(campaignId: String)
    func deleteActualCampaignSettings()
    func deleteAllCampaignsSettings()
}

class CampaignSettingsRepository: NSObject, ICampaignSettingsRepository {
    
    lazy private var _settingsSelected =
        BehaviorRelay<ICampaignSettings>.init(value: initialSettings)
    
    private var initialSettings: ICampaignSettings
    
    static var shared = CampaignSettingsRepository()
    
    private var campaignId: String = ""
    private var campaignIds = CampaignIds()
    
    func campaignSelected(campaignId: String) {
        self.campaignId = campaignId
        let existingSettings = CampaignSettingsUserDefaultsRepo.read(campaignId: campaignId)
        postUpdateOnOutput(userSelection: existingSettings)
    }
    
    // API: input, output
    var userSelection: ICampaignSettings {
        get {
            CampaignSettingsUserDefaultsRepo.read(campaignId: campaignId)
        }
        set {
            CampaignSettingsUserDefaultsRepo.save(selection: newValue, campaignId: campaignId)
            campaignIds.add(campaignId: campaignId)
            postUpdateOnOutput(userSelection: newValue)
        }
    }
    
    private func postUpdateOnOutput(userSelection: ICampaignSettings) {
        _settingsSelected.accept(userSelection)
    }
    
    func deleteActualCampaignSettings() {
        UserDefaults.standard.set(nil, forKey: "campaignId" + campaignId)
        campaignIds.remove(campaignId: campaignId)
        _settingsSelected.accept(CampaignSettings())
    }
    
    func deleteAllCampaignsSettings() {
        campaignIds.removeAll()
        _settingsSelected.accept(CampaignSettings())
    }
    
    // API: output
    
    var obsCampSettings: Observable<ICampaignSettings> {
        return _settingsSelected.asObservable()
    }
    
    override init() {
        if let campaignId = CampaignSelectionRepositoryFactory.make().getSelected()?.getCampaignId() {
            self.initialSettings = CampaignSettingsUserDefaultsRepo.read(campaignId: campaignId)
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
    var blockId: Int? {get set} // set because of autoSession timer
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
    static func save(selection: ICampaignSettings, campaignId: String) {
        var settings = [String : Any]()
        if selection.roomId != nil { settings["roomId"] = selection.roomId }
        if selection.blockId != nil { settings["blockId"] = selection.blockId }
        if selection.selectedDate != nil { settings["date"] = selection.selectedDate }
        settings["autoSwitch"] = selection.autoSwitch
        UserDefaults.standard.set(settings, forKey: "campaignId" + campaignId)
    }
}
