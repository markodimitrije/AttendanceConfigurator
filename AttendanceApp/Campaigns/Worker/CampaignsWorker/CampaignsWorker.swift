//
//  CampaignsWorker.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 20/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

extension CampaignsWorker: ICampaignsWorker {
    func fetchCampaigns() -> Observable<Void> {
        Observable.deferred { [weak self] () -> Observable<Void> in
            guard let sSelf = self else {
                return Observable.just(())
            }
            return sSelf.remoteApi.fetchCampaigns()
                        .flatMap(sSelf.campaignsRepo.save)
                        .map {_ in return ()}
        }
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        .observeOn(MainScheduler.instance)
    }
    
}

class CampaignsWorker {
    private let remoteApi: ICampaignsRemoteApi
    private let campaignsRepo: ICampaignsMutableRepository
    private let bag = DisposeBag()
    
    init(remoteApi: ICampaignsRemoteApi, campaignsRepo: ICampaignsMutableRepository) {
        self.remoteApi = remoteApi
        self.campaignsRepo = campaignsRepo
    }
}

