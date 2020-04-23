//
//  CampaignsRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift
import RealmSwift

extension CampaignsRepository: ICampaignsRepository {
    func save(campaigns: [ICampaign]) -> Observable<[ICampaign]> {
        let realmCampaigns = campaigns.map(RealmCampaignFactory.make)
        return genericRepo
            .saveToRealm(objects: realmCampaigns)
            .map { (success) -> [ICampaign] in
                return success ? campaigns : [ ]
            }
    }
    func deleteAll() {
        genericRepo.deleteAllObjects(ofTypes: [RealmCampaign.self])
    }
    func getAll() -> Observable<[ICampaign]> {
        let realm = try! Realm()
        let valid = realm.objects(RealmCampaign.self).filter("deletedAt == nil")
        let obsResults = Observable.collection(from: valid)
        return obsResults.map {$0.toArray().map(CampaignFactory.make)}
    }
    
}

class CampaignsRepository {
    private let genericRepo: GenericRealmRepository
    init(genericRepo: GenericRealmRepository) {
        self.genericRepo = genericRepo
    }
}

class CampaignFactory {
    static func make(realmCampaign: RealmCampaign) -> ICampaign {
        return Campaign(id: realmCampaign.id,
                        name: realmCampaign.name,
                        description: realmCampaign.desc,
                        logo: realmCampaign.logo,
                        conferenceId: realmCampaign.conferenceId,
                        restrictedAccess: realmCampaign.restrictedAccess,
                        createdAt: realmCampaign.createdAt,
                        updatedAt: realmCampaign.updatedAt,
                        deletedAt: realmCampaign.deletedAt)
    }
}
