//
//  MutableCampaignResourcesRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 29/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

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
}
