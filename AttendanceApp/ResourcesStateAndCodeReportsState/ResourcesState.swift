//
//  Logic.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 30/10/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import Realm

class ResourcesState {
    
    lazy var oResourcesDownloaded = BehaviorRelay<Bool>.init(value: false)//.skip(1) hard-coded
    
    var resourcesDownloaded: Bool? {
        get {
            return UserDefaults.standard.value(forKey: UserDefaults.keyResourcesDownloaded) as? Bool
        }
        set {
            UserDefaults.standard.set(true, forKey: UserDefaults.keyResourcesDownloaded)
        }
    }
    
    var shouldDownloadResources: Bool {
//        if resourcesDownloaded == nil || resourcesDownloaded == false {
//            return true
//        } else {
//            return false
//        }
        return true // hard-coded
    }
    
    var oAppDidBecomeActive = BehaviorSubject<Void>.init(value: ())
    
    private var timer: Timer?
    
    private let bag = DisposeBag()
    
    private var downloads = PublishSubject<Bool>.init() // refactor u tuple or dict ["blocks": true, "rooms": false]...
    private let downloadsState = DownloadsState()
    
    init() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.appWillEnterBackground),
            name: UIApplication.willResignActiveNotification,
            object: nil)
        
        
        
//        downloads.subscribe(onNext: { [weak self] _ in guard let sSelf = self else {return}
//            if sSelf.downloadsState.downloads.value.keys.count == 3 && (sSelf.downloadsState.downloads.value.values.filter {$0}).count == 3 {
//                print("svi su TRUE, odlicno !!!")
//
//                sSelf.resourcesDownloaded = true // bez veze je ovo
//                sSelf.oResourcesDownloaded.accept(true) // na 2 mesta sync !
//            }
//        }).disposed(by: bag)

        downloadsState.downloads.subscribe(onNext: { resources in
            if resources.count >= 3 {
                self.resourcesDownloaded = true // bez veze je ovo
                self.oResourcesDownloaded.accept(true) // na 2 mesta sync !
                //self.downloadsState.resourceStateUpdated()
            }
        }).disposed(by: bag)
        
        
//        downloads
//            .take(3) // room API and blocks API
//            .reduce(true) { (sum, last) -> Bool in
//                sum && last
//            }
//            .subscribe(onNext: { [weak self] success in
//                guard let sSelf = self else {return}
//                sSelf.resourcesDownloaded = success // bez veze je ovo
//                sSelf.oResourcesDownloaded.accept(true) // na 2 mesta sync !
////                sSelf.timer?.invalidate() hard-coded (there is no silent notification to force download resources)
//                // thats why timer should be always alive, to force download resources every 30 min for example
//            })
//            .disposed(by: bag)
        
    }
    
    @objc private func appDidBecomeActive() { // print("ResourcesState/ appDidBecomeActive/ appDidBecomeActive is called")
        
        oAppDidBecomeActive.onNext(())
        
        downloadResources()
        
    }
    
    func downloadResources() {
        
        if shouldDownloadResources {
            
            fetchResourcesFromWeb()
            
            if timer == nil {
                
                timer = Timer.scheduledTimer(
                    timeInterval: MyTimeInterval.timerForFetchingRoomAndBlockResources,
                    target: self,
                    selector: #selector(ResourcesState.fetchResourcesFromWeb),
                    userInfo: nil,
                    repeats: true)
            } else {
                print("else - leave fetching loop, timer != nil ?!??!?!??!?!")
            }
        }
        
    }
    
    @objc private func appWillEnterBackground() {// print("ResourcesState/ appWillEnterForeground is called")
        
        timer?.invalidate()
    }
    
    @objc private func fetchResourcesFromWeb() { // print("fetchRoomsAndBlocksResources is called")
        
        print("ResourceState.fetchRoomsAndBlocksResources is called, date = \(Date.now)")
        
        fetchRoomsAndSaveToRealm()
        fetchSessionsAndSaveToRealm()
        fetchDelegatesAndSaveToRealm()
        
    }
    
    private func fetchRoomsAndSaveToRealm() { // print("fetchRoomsAndSaveToRealm is called")
        
        let oRooms = ApiController.shared.getRooms(updated_from: nil,
                                                   with_pagination: 0,
                                                   with_trashed: 0)
        oRooms
            .subscribe(onNext: { [ weak self] (rooms) in
                
                guard let sSelf = self,
                    rooms.count > 0 else {return} // valid
                
                RealmDataPersister.shared.deleteAllObjects(ofTypes: [RealmRoom.self])
                    .subscribe(onNext: { (success) in
    
                        if success {
                            
                            RealmDataPersister.shared.save(rooms: rooms)
                                .subscribe(onNext: { (success) in
                                    
                                    sSelf.downloads.onNext(success)
                                    //strongSelf.downloadsState.downloads.accept("rooms")
                                    sSelf.downloadsState.newlyDownloaded.accept("rooms")
                                    
                                })
                                .disposed(by: sSelf.bag)
                        }
                        
                }).disposed(by: sSelf.bag)
                
            })
            .disposed(by: bag)
        
    } // hard coded off for testing
    
    private func fetchSessionsAndSaveToRealm() { // print("fetchSessionsAndSaveToRealm is called")
        
        let oBlocks = ApiController.shared.getBlocks(updated_from: nil,
                                                     with_pagination: 0,
                                                     with_trashed: 0,
                                                     for_scanning: 1)
        oBlocks
            .subscribe(onNext: { [weak self] (blocks) in
                
                guard let sSelf = self,
                    blocks.count > 0 else {return} // valid
                
                RealmDataPersister.shared.deleteAllObjects(ofTypes: [RealmBlock.self])
                    .subscribe(onNext: { (success) in
                        
                        if success {
                            
                            RealmDataPersister.shared.save(blocks: blocks)
                                .subscribe(onNext: { (success) in
                                    
                                    sSelf.downloads.onNext(success)
                                    //sSelf.downloadsState.downloads.accept(["blocks": success])
                                    sSelf.downloadsState.newlyDownloaded.accept("blocks")
                                    
                                })
                                .disposed(by: sSelf.bag)
                        }
                        
                    }).disposed(by: sSelf.bag)
                
            })
            .disposed(by: bag)
    } // hard coded off for testing
    
    private func fetchDelegatesAndSaveToRealm() {
        
        let oNewDelegates = DelegatesAPIController.shared.getDelegates()
        
        let oOldDeleted = RealmDelegatesPersister.shared
            .deleteAllObjects(ofTypes: [RealmDelegate.self])
            .filter {$0}
        
        let result = Observable.combineLatest(oNewDelegates, oOldDeleted) { (delegates, success) -> [Delegate] in
            return success ? delegates : [ ]
        }
        
        result.flatMap(RealmDelegatesPersister.shared.save)
            .subscribe(onNext: { [weak self] success in guard let sSelf = self else {return}
                sSelf.downloads.onNext(success)
                //sSelf.downloadsState.downloads.accept(["delegates": success])
                sSelf.downloadsState.newlyDownloaded.accept("delegates")
            })
            .disposed(by: self.bag)
        
    }
    
    deinit {
        print("ResourcesState.deinit is called")
    }
    
}

class ConferenceState {
    
    var apiKey: String? = UserDefaults.standard.value(forKey: UserDefaults.keyConferenceApiKey) as? String
    
    init() {
        listenToResourcesDowloaded()
    }
    
    func syncApiKeyIsNeeded() {
        
        getNewApiKey()
            .subscribe(onNext: { newApiKey in
                if newApiKey != self.getActualApiKey() {
                    self.apiKey = newApiKey
                    resourcesState.downloadResources()
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

class DownloadsState {
    
    // OUTPUT:
    var downloads = BehaviorRelay<[String]>.init(value: [])
    
    // INPUT:
    let newlyDownloaded = BehaviorRelay<String>.init(value: "")
    
    init() {
        newlyDownloaded
            .subscribe(onNext: { [weak self] newResource in
                guard let sSelf = self else {return}
                if newResource != "" {
                    var resources = sSelf.downloads.value
                    resources.append(newResource)
                    sSelf.downloads.accept(resources)
                }
            }).disposed(by: bag)
    }
    
    func resourceStateUpdated() {
        downloads.accept([])
    }
    
    private let bag = DisposeBag()
}
