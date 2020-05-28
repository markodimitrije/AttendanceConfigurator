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
        self.campaignResourcesRepo.deleteResources()
        return fetchCampaignResourcesAndSaveToRealm()
//        fetchCampaignResourcesGotError() //test
    }
    
    private func fetchCampaignResourcesAndSaveToRealm() -> Observable<Void> {
        resourcesApiController.fetch().take(1).delay(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance) // TODO marko: campaignResourcesRepo.save should be Observable!
        .do(onNext: { (resources) in
            print("CampaignResourcesWorker.work PERSIST resources")
            self.campaignResourcesRepo.save(resources: resources)
        }).map {_ in return ()}
        .observeOn(MainScheduler.asyncInstance)
    }
    
    private func fetchCampaignResourcesGotError() -> Observable<Void> { // test
        return Observable.create { (observer) -> Disposable in
            observer.onError(LoginValidationError.emailNotValid)
            return Disposables.create()
        }.delaySubscription(1, scheduler: MainScheduler.instance)
    }
    
}

struct CampaignResourcesWorker {
    let resourcesApiController: ICampaignResourcesApiController
    let campaignResourcesRepo: IMutableCampaignResourcesRepository
}
