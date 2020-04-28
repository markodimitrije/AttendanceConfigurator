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

protocol IResourcesState {
    func downloadResources()
    var oResourcesDownloaded: Observable<Bool> {get}
}

class ResourcesState: IResourcesState {
    
    private let roomProviderWorker: IRoomProviderWorker
    private let blockProviderWorker: IBlockProviderWorker
    private let delegateProviderWorker: IDelegateProviderWorker
    private let dataAccess: DataAccess
    
    init(dataAccess: DataAccess,
         roomProviderWorker: IRoomProviderWorker,
         blockProviderWorker: IBlockProviderWorker,
         delegateProviderWorker: IDelegateProviderWorker) {
        self.dataAccess = dataAccess
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
            let successDownloads = resources.count >= 3
            self.resourcesDownloaded = successDownloads // bez veze je ovo
            self._oResourcesDownloaded.accept(successDownloads) // na 2 mesta sync !
//            if resources.count >= 2 { // rooms and blocks
//                dataAccess.userSelection = (nil, nil, nil, false)
//            }
        }).disposed(by: bag)
    }
    
    lazy var _oResourcesDownloaded = BehaviorRelay<Bool>.init(value: false)
    
    var resourcesDownloaded: Bool? {
        get {
            return UserDefaults.standard.value(forKey: UserDefaults.keyResourcesDownloaded) as? Bool
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.keyResourcesDownloaded)
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
    
    var oResourcesDownloaded: Observable<Bool> {
        return _oResourcesDownloaded.asObservable()
    }
    
    func downloadResources() {
        
        fetchResourcesFromWeb()
        
        if timer == nil { print("creating timer to fetch resources")
            
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
        
        
    }
    
    deinit { print("ResourcesState.deinit is called") }
    
}

extension CampaignResourcesState: IResourcesState {
    
    func downloadResources() {
        
        fetchResourcesFromWeb()
        
        if timer == nil { print("creating timer to fetch resources")
            
            timer = Timer.scheduledTimer(
                timeInterval: MyTimeInterval.timerForFetchingRoomBlockDelegateResources,
                target: self,
                selector: #selector(CampaignResourcesState.fetchResourcesFromWeb),
                userInfo: nil,
                repeats: true)
        }
        
    }
    var oResourcesDownloaded: Observable<Bool> {
        return _oResourcesDownloaded
    }
}

class CampaignResourcesState {
    private let bag = DisposeBag()
    private var timer: Timer?
    private var _oResourcesDownloaded = PublishSubject<Bool>()
    
    private let campaignResourcesWorker: ICampaignResourcesWorker
    init(campaignResourcesWorker: ICampaignResourcesWorker) {
        self.campaignResourcesWorker = campaignResourcesWorker
    }
    
    @objc private func fetchResourcesFromWeb() {
        
        self.campaignResourcesWorker.work()
        .subscribe(onError: { [weak self] (err) in
            self?._oResourcesDownloaded.onNext(false)
        }, onCompleted: { [weak self] in
            self?._oResourcesDownloaded.onNext(true)
        }).disposed(by: bag)
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
}

class CampaignResourcesStateFactory {
    static func make() -> IResourcesState {
        let worker = CampaignResourcesWorkerFactory.make()
        return CampaignResourcesState(campaignResourcesWorker: worker)
    }
}
