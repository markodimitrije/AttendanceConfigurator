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

/*fetchRoomsAndSaveToRealm()
 fetchSessionsAndSaveToRealm()
 fetchDelegatesAndSaveToRealm()*/

class ResourcesState {
    
    private var roomProviderWorker: IRoomProviderWorker
    private var blockProviderWorker: IBlockProviderWorker
    private var delegateProviderWorker: IDelegateProviderWorker
    
    init(roomProviderWorker: IRoomProviderWorker, blockProviderWorker: IBlockProviderWorker, delegateProviderWorker: IDelegateProviderWorker) {
        self.roomProviderWorker = roomProviderWorker
        self.blockProviderWorker = blockProviderWorker
        self.delegateProviderWorker = delegateProviderWorker
        
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

        downloadsState.downloads.subscribe(onNext: { resources in
            if resources.count >= 3 {
                self.resourcesDownloaded = true // bez veze je ovo
                self.oResourcesDownloaded.accept(true) // na 2 mesta sync !
                //self.downloadsState.resourceStateUpdated()
            }
        }).disposed(by: bag)
    }
    
    lazy var oResourcesDownloaded = BehaviorRelay<Bool>.init(value: false)
    
    var resourcesDownloaded: Bool? {
        get {
            return UserDefaults.standard.value(forKey: UserDefaults.keyResourcesDownloaded) as? Bool
        }
        set {
            UserDefaults.standard.set(true, forKey: UserDefaults.keyResourcesDownloaded)
        }
    }
    
    var oAppDidBecomeActive = BehaviorSubject<Void>.init(value: ())
    
    private var timer: Timer?
    
    private let bag = DisposeBag()
    
    private let downloadsState = DownloadResourcesState()
    
    @objc private func appDidBecomeActive() {
        
        oAppDidBecomeActive.onNext(())
        downloadResources()
    }
    
    func downloadResources() {
        
        fetchResourcesFromWeb()
        
        if timer == nil {
            print("creating timer to fetch resources")
            timer = Timer.scheduledTimer(
                timeInterval: MyTimeInterval.timerForFetchingRoomBlockDelegateResources,
                target: self,
                selector: #selector(ResourcesState.fetchResourcesFromWeb),
                userInfo: nil,
                repeats: true)
        }
        
    }
    
    @objc private func appWillEnterBackground() {// print("ResourcesState/ appWillEnterForeground is called")
        
        timer?.invalidate()
    }
    
    @objc private func fetchResourcesFromWeb() { // print("fetchRoomsAndBlocksResources is called")
        
        print("ResourceState.fetchRoomsAndBlocksResources is called, date = \(Date.now)")
        
        roomProviderWorker.fetchRoomsAndPersistOnDevice()
            .subscribe(onNext: { _ in
                self.downloadsState.newlyDownloaded.accept("rooms")
            }).disposed(by: bag)
        blockProviderWorker.fetchBlocksAndPersistOnDevice()
            .subscribe(onNext: { _ in
                self.downloadsState.newlyDownloaded.accept("blocks")
            }).disposed(by: bag)
        delegateProviderWorker.fetchDelegatesAndPersistOnDevice()
            .subscribe(onNext: { _ in
                self.downloadsState.newlyDownloaded.accept("delegates")
            }).disposed(by: bag)
        
//        fetchRoomsAndSaveToRealm()
//        fetchSessionsAndSaveToRealm()
//        fetchDelegatesAndSaveToRealm()
        
        
    }
    
    /*
    
    private func fetchRoomsAndSaveToRealm() { // print("fetchRoomsAndSaveToRealm is called")
        
        let oRooms = ApiController.shared.getRooms()
        oRooms
            .subscribe(onNext: { [ weak self] (rooms) in
                
                guard let sSelf = self,
                    rooms.count > 0 else {return} // valid
                
                RealmDataPersister.shared.deleteAllObjects(ofTypes: [RealmRoom.self])
                    .subscribe(onNext: { (success) in
    
                        if success {
                            
                            RealmDataPersister.shared.save(rooms: rooms)
                                .subscribe(onNext: { (success) in
                                    
                                    sSelf.downloadsState.newlyDownloaded.accept("rooms")
                                    
                                })
                                .disposed(by: sSelf.bag)
                        }
                        
                }).disposed(by: sSelf.bag)
                
            })
            .disposed(by: bag)
        
    } // hard coded off for testing
    
    private func fetchSessionsAndSaveToRealm() { // print("fetchSessionsAndSaveToRealm is called")
        
        let oBlocks = ApiController.shared.getBlocks()
        
        oBlocks.subscribe(onNext: { [weak self] (blocks) in
            guard let sSelf = self else { return }
            sSelf.save(blocks: blocks)
        }, onError: { (err) in
            print("catch err = show alert...")
        })
        .disposed(by: bag)
        
    } // hard coded off for testing
    
    private func save(blocks: [Block]) {
        
        RealmDataPersister.shared.deleteAllObjects(ofTypes: [RealmBlock.self])
            .subscribe(onNext: { (success) in
                if success {
                    RealmDataPersister.shared.save(blocks: blocks)
                        .subscribe(onNext: { (success) in
                            
                            self.downloadsState.newlyDownloaded.accept("blocks")
                        })
                        .disposed(by: self.bag)
                }
            }).disposed(by: self.bag)
    }
    
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

                sSelf.downloadsState.newlyDownloaded.accept("delegates")
            })
            .disposed(by: self.bag)
        
    }
    
    */
    
    
    deinit {
        print("ResourcesState.deinit is called")
    }
    
}

/*
class ResourcesState {
    
    lazy var oResourcesDownloaded = BehaviorRelay<Bool>.init(value: false)
    
    var resourcesDownloaded: Bool? {
        get {
            return UserDefaults.standard.value(forKey: UserDefaults.keyResourcesDownloaded) as? Bool
        }
        set {
            UserDefaults.standard.set(true, forKey: UserDefaults.keyResourcesDownloaded)
        }
    }
    
    var oAppDidBecomeActive = BehaviorSubject<Void>.init(value: ())
    
    private var timer: Timer?
    
    private let bag = DisposeBag()
    
    private let downloadsState = DownloadResourcesState()
    
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

        downloadsState.downloads.subscribe(onNext: { resources in
            if resources.count >= 3 {
                self.resourcesDownloaded = true // bez veze je ovo
                self.oResourcesDownloaded.accept(true) // na 2 mesta sync !
                //self.downloadsState.resourceStateUpdated()
            }
        }).disposed(by: bag)
        
    }
    
    @objc private func appDidBecomeActive() {
        
        oAppDidBecomeActive.onNext(())
        downloadResources()
    }
    
    func downloadResources() {
        
        fetchResourcesFromWeb()
        
        if timer == nil {
            print("creating timer to fetch resources")
            timer = Timer.scheduledTimer(
                timeInterval: MyTimeInterval.timerForFetchingRoomBlockDelegateResources,
                target: self,
                selector: #selector(ResourcesState.fetchResourcesFromWeb),
                userInfo: nil,
                repeats: true)
        }
        
    }
    
    @objc private func appWillEnterBackground() {// print("ResourcesState/ appWillEnterForeground is called")
        
        timer?.invalidate()
    }
    
    @objc private func fetchResourcesFromWeb() { // print("fetchRoomsAndBlocksResources is called")
        
        print("ResourceState.fetchRoomsAndBlocksResources is called, date = \(Date.now)")
        
//        fetchRoomsAndSaveToRealm()
//        fetchSessionsAndSaveToRealm()
//        fetchDelegatesAndSaveToRealm()
        
        
    }
    
    /*
    
    private func fetchRoomsAndSaveToRealm() { // print("fetchRoomsAndSaveToRealm is called")
        
        let oRooms = ApiController.shared.getRooms()
        oRooms
            .subscribe(onNext: { [ weak self] (rooms) in
                
                guard let sSelf = self,
                    rooms.count > 0 else {return} // valid
                
                RealmDataPersister.shared.deleteAllObjects(ofTypes: [RealmRoom.self])
                    .subscribe(onNext: { (success) in
    
                        if success {
                            
                            RealmDataPersister.shared.save(rooms: rooms)
                                .subscribe(onNext: { (success) in
                                    
                                    sSelf.downloadsState.newlyDownloaded.accept("rooms")
                                    
                                })
                                .disposed(by: sSelf.bag)
                        }
                        
                }).disposed(by: sSelf.bag)
                
            })
            .disposed(by: bag)
        
    } // hard coded off for testing
    
    private func fetchSessionsAndSaveToRealm() { // print("fetchSessionsAndSaveToRealm is called")
        
        let oBlocks = ApiController.shared.getBlocks()
        
        oBlocks.subscribe(onNext: { [weak self] (blocks) in
            guard let sSelf = self else { return }
            sSelf.save(blocks: blocks)
        }, onError: { (err) in
            print("catch err = show alert...")
        })
        .disposed(by: bag)
        
    } // hard coded off for testing
    
    private func save(blocks: [Block]) {
        
        RealmDataPersister.shared.deleteAllObjects(ofTypes: [RealmBlock.self])
            .subscribe(onNext: { (success) in
                if success {
                    RealmDataPersister.shared.save(blocks: blocks)
                        .subscribe(onNext: { (success) in
                            
                            self.downloadsState.newlyDownloaded.accept("blocks")
                        })
                        .disposed(by: self.bag)
                }
            }).disposed(by: self.bag)
    }
    
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

                sSelf.downloadsState.newlyDownloaded.accept("delegates")
            })
            .disposed(by: self.bag)
        
    }
    
    */
    
    
    deinit {
        print("ResourcesState.deinit is called")
    }
    
}
*/
