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
        remoteApi.getCampaigns()
            .flatMap(campaignsRepo.save)
            .map {_ in return ()}
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
