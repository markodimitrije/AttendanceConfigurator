//
//  ConferenceApiKeyState.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 03/06/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import RxCocoa
import RxSwift

class ConferenceApiKeyState {
    
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
}
