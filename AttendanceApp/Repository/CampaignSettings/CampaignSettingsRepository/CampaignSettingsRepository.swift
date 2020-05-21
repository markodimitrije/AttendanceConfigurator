//
//  CampaignSettingsRepository.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 04/12/2018.
//  Copyright © 2018 Navus. All rights reserved.
//

import RxSwift
import RxCocoa

class CampaignSettingsRepository: NSObject, ICampaignSettingsRepository { // TODO marko:
    // replace with Realm version
    
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
