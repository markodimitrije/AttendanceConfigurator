//
//  CampaignResourcesRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

extension CampaignResourcesRepository: ICampaignResourcesRepository {
    func save(resources: ICampaignResources) {
        let realmCampaignResources = RealmCampaignResourcesFactory.make(resources: resources)
        let genRepo = GenRealmMutableRepo()
        try? genRepo.save(objects: [realmCampaignResources])
    }
}

struct CampaignResourcesRepository {
    let roomsRepo: IRoomRepository
    let blocksRepo: IBlockMutableRepository
    let delegatesRepo: IDelegatesRepository
}
