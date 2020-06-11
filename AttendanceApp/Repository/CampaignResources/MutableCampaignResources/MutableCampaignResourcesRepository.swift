//
//  MutableCampaignResourcesRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 29/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

extension MutableCampaignResourcesRepository: IMutableCampaignResourcesRepository {
    func deleteResources() {
        try? genMutRepo.delete(type: RealmCampaignResources.self, filter: NSPredicate.truePredicate)
        roomsRepo.deleteAllRooms()
        blocksRepo.deleteAllBlocks()
        _ = delegatesRepo.deleteAllDelegates()
    }
    func save(resources: ICampaignResources) {
        let realmCampaignResources = RealmCampaignResourcesFactory.make(resources: resources)
        let genRepo = GenRealmMutableRepo()
        try? genRepo.save(objects: [realmCampaignResources])
    }
    func obsSave(resources: ICampaignResources) -> Observable<Void> {
        Observable.create { (observer) -> Disposable in
            let realmCampaignResources = RealmCampaignResourcesFactory.make(resources: resources)
            let genRepo = GenRealmMutableRepo()
            do {
                try genRepo.save(objects: [realmCampaignResources])
                observer.onNext(())
                observer.onCompleted()
            } catch let err {
                observer.onError(err)
            }
            return Disposables.create()
        }
    }
}
