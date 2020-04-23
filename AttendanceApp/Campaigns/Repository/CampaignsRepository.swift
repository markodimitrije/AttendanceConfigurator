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
    func getLogoUpdateInfos() -> [ILogoUpdateInfo] {
        let realm = try! Realm()
        let results = realm.objects(RealmCampaign.self).filter("imgData == nil").toArray()
        return results.compactMap { LogoUpdateInfo(id: $0.id, address: $0.logo) }
    }
    func updateLogo(id: String, data: Data) {
        let realm = try! Realm()
        let campaign = realm.object(ofType: RealmCampaign.self, forPrimaryKey: id)
        try? realm.write {
            campaign?.imgData = data
        }
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
        let image = (realmCampaign.imgData != nil) ? UIImage(data: realmCampaign.imgData!)!
                                                   : CAMPAIGN_DEF_IMG
        return Campaign(id: realmCampaign.id,
                        name: realmCampaign.name,
                        description: realmCampaign.desc,
                        logo: realmCampaign.logo,
                        conferenceId: realmCampaign.conferenceId,
                        restrictedAccess: realmCampaign.restrictedAccess,
                        createdAt: realmCampaign.createdAt,
                        image: image)
    }
}
