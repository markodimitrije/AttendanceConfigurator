//
//  CampaignsRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

extension CampaignsRepository: ICampaignsRepository {
    func save(campaigns: [ICampaign]) -> Observable<[ICampaign]> {
        genericRepo.saveToRealm(objects: []).map { (success) -> [ICampaign] in
            return campaigns
        }
    }
    func deleteAll() {
        //genericRepo.deleteAllObjects(ofTypes: RealmCampaign.self)
    }
    func getAll() -> Observable<[ICampaign]> {
        Observable.just([])// TODO marko
    }
}

class CampaignsRepository {
    private let genericRepo: GenericRealmRepository
    init(genericRepo: GenericRealmRepository) {
        self.genericRepo = genericRepo
    }
}
