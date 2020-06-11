//
//  CampaignResourcesWorker.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 27/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

extension CampaignResourcesWorker: ICampaignResourcesWorker {
    func work() -> Observable<Void> {
        fetchCampaignResourcesAndSaveToRealm()
//        fetchCampaignResourcesGotError() //test
    }
    
    private func fetchCampaignResourcesAndSaveToRealm() -> Observable<Void> {
        resourcesApiController.fetch().take(1)
            .flatMap(campaignResourcesRepo.obsSave)
        .observeOn(MainScheduler.asyncInstance)
    }
    
    private func fetchCampaignResourcesGotError() -> Observable<Void> { // test
        return Observable.create { (observer) -> Disposable in
            observer.onError(LoginValidationError.emailNotValid)
            return Disposables.create()
        }.delaySubscription(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
    }
    
}

struct CampaignResourcesWorker {
    let resourcesApiController: ICampaignResourcesApiController
    let campaignResourcesRepo: IMutableCampaignResourcesRepository
}
