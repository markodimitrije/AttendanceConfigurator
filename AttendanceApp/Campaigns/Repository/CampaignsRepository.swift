//
//  CampaignsRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

extension CampaignsRepository: ICampaignsRepository {
    func save(campaigns: [ICampaign]) {
        _ = genericRepo.saveToRealm(objects: []) //TODO marko
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
