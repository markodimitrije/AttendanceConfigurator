//
//  ConfIdApiKeyAuthState.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 03/06/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

 /*ConferenceApiKeyState {
    
    var apiKey: String? = UserDefaults.standard.value(forKey: UserDefaults.keyConferenceApiKey) as? String
    
    init() {
        listenToResourcesDowloaded()
    }
    
    func syncApiKeyIsNeeded() {
        
        getNewApiKey()
            .subscribe(onNext: { newApiKey in
                if newApiKey != self.getActualApiKey() {
                    self.apiKey = newApiKey
                    resourcesState.downloadResources() // side-effect...
                    DataAccess.shared.userSelection = (roomId: nil, blockId: nil, selectedDate: nil, autoSwitch: true)
                }
            })
            .disposed(by: self.bag)
    }
    
    private func listenToResourcesDowloaded() {
        
        resourcesState.oResourcesDownloaded
            .subscribe(onNext: { downloaded in
                UserDefaults.standard.set(downloaded, forKey: UserDefaults.keyResourcesDownloaded)
                UserDefaults.standard.set(self.apiKey, forKey: UserDefaults.keyConferenceApiKey)
            })
            .disposed(by: self.bag)
    }
    
    private func getNewApiKey() -> Observable<String?> {
        return ApiController.shared.getApiKey()
    }
    
    private func getActualApiKey() -> String? {
        return UserDefaults.standard.value(forKey: UserDefaults.keyConferenceApiKey) as? String
    }
    
    private let bag = DisposeBag()
}*/


class ConferenceApiKeyState: ConfIdApiKeyAuthSupplying {
    
    var conferenceId: Int? {
        get {
            return UserDefaults.standard.value(forKey: UserDefaults.keyConferenceId) as? Int
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.keyConferenceId)
        }
    }
    var apiKey: String? {
        get {
            return UserDefaults.standard.value(forKey: UserDefaults.keyConferenceApiKey) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.keyConferenceApiKey)
        }
    }
    var authentication: String? {
        get {
            return UserDefaults.standard.value(forKey: UserDefaults.keyConferenceAuth) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.keyConferenceAuth)
        }
    }
    
    init() {
        
        if UserDefaults.standard.value(forKey: UserDefaults.keyConferenceApiKey) == nil {
            UserDefaults.standard.set("Kx8YQFIFvC0VJK7xU5p8hOVVF5hHPO6T", forKey: UserDefaults.keyConferenceApiKey)
        }
        if UserDefaults.standard.value(forKey: UserDefaults.keyConferenceId) == nil {
            UserDefaults.standard.set(7520, forKey: UserDefaults.keyConferenceId)
        }
        
        listenToResourcesDowloaded()
    }
    
    func syncApiKeyIsNeeded() {
        
        getNewApiKey()
            .subscribe(onNext: { newApiKey in
                if newApiKey != self.getActualApiKey() {
                    self.apiKey = newApiKey
                    if newApiKey == "L5YYQFIFvC0VJK7xU5p8hOVVF5hHPMKL" {
                        self.conferenceId = 7498
                    }
                    resourcesState.downloadResources() // side-effect...
                    DataAccess.shared.userSelection = (roomId: nil, blockId: nil, selectedDate: nil, autoSwitch: true)
                }
            })
            .disposed(by: self.bag)
    }
    
    private func listenToResourcesDowloaded() {
        
        resourcesState.oResourcesDownloaded
            .subscribe(onNext: { downloaded in
                UserDefaults.standard.set(downloaded, forKey: UserDefaults.keyResourcesDownloaded)
                UserDefaults.standard.set(self.apiKey, forKey: UserDefaults.keyConferenceApiKey)
            })
            .disposed(by: self.bag)
    }
    
    private func getNewApiKey() -> Observable<String?> {
        return ApiController.shared.getApiKey()
    }
    
    private func getActualApiKey() -> String? {
        return UserDefaults.standard.value(forKey: UserDefaults.keyConferenceApiKey) as? String
    }
    
    private let bag = DisposeBag()
}
