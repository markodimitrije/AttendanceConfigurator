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
        .do(onNext: { (resources) in
            print("CampaignResourcesWorker.work PERSIST resources")
            self.campaignResourcesRepo.save(resources: resources)
        }).map {_ in return ()}
        .subscribeOn(MainScheduler.instance)
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
    let campaignResourcesRepo: ICampaignResourcesRepository
}

protocol ICampaignResourcesRepository {
    func save(resources: ICampaignResources)
}

extension CampaignResourcesRepository: ICampaignResourcesRepository {
    func save(resources: ICampaignResources) {
        let realmCampaignResources = MyCampaignResourcesRealmFactory.make(resources: resources)
        let genRepo = GenRealmMutableRepo()
        try? genRepo.save(objects: [realmCampaignResources])
    }
}

struct CampaignResourcesRepository {
    let roomsRepo: IRoomRepository
    let blocksRepo: IBlockMutableRepository
    let delegatesRepo: IDelegatesRepository
}

import RealmSwift

class RealmCampaignResources: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var confDataVersion: Int = 0
    let rooms = List<RealmRoom>()
    let blocks = List<RealmBlock>()
    let delegates = List<RealmDelegate>()
    
    override class func primaryKey() -> String? { "id" }
}

class MyCampaignResourcesFactory {
    static func make(data: Data) throws -> ICampaignResources {
        let dictionary = try DataToDictFactory.make(data: data)
        guard let campaignId = dictionary["campaign_id"] as? String,
            let confDataVersionId = dictionary["conference_data_version_id"] as? Int,
            let locDicts = dictionary["locations"] as? [[String: Any]],
            let tsDicts = dictionary["timeslot_distributions"] as? [[String: Any]],
            let delDicts = dictionary["delegates"] as? [[String: Any]] else {
                throw ApiError.invalidJson
        }
        return CampaignResources(campaignId: campaignId,
                                 confDataVersionId: confDataVersionId,
                                 locations: locDicts.compactMap(RoomFactory.make),
                                 blocks: tsDicts.compactMap(BlockFactory.make),
                                 delegates: delDicts.compactMap(DelegateFactory.make))

    }
    static func make(rResources: RealmCampaignResources) -> ICampaignResources {
        CampaignResources(campaignId: rResources.id,
                          confDataVersionId: rResources.confDataVersion,
                          locations: rResources.rooms.map(RoomFactory.make),
                          blocks: rResources.blocks.map(BlockFactory.make),
                          delegates: rResources.delegates.map(DelegateFactory.make))
    }
}

class MyCampaignResourcesRealmFactory {
    static func make(resources: ICampaignResources) -> RealmCampaignResources {
        
        let rResources = RealmCampaignResources()
        rResources.id = resources.getCampaignId()
        rResources.confDataVersion = resources.getConfDataVersionId()
        
        let rooms = resources.getLocations().map(RealmRoomFactory.make)
        rResources.rooms.insert(contentsOf: rooms, at: 0)
        
        let blocks = resources.getBlocks().map(RealmBlockFactory.make)
        rResources.blocks.insert(contentsOf: blocks, at: 0)
        
        let delegates = resources.getDelegates().map(RealmDelegateFactory.make)
        rResources.delegates.insert(contentsOf: delegates, at: 0)
        
        return rResources
    }
}
