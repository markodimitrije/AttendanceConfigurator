//
//  IMutableCampaignResourcesRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 29/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

protocol IMutableCampaignResourcesRepository {
    func save(resources: ICampaignResources)
    func deleteResources()
}

class MutableCampaignResourcesRepositoryFactory {
    static func make() -> IMutableCampaignResourcesRepository {
        return MutableCampaignResourcesRepository(
            genMutRepo: GenRealmMutableRepo(),
            roomsRepo: RoomRepository(),
            blocksRepo: BlockMutableRepositoryFactory.make(),
            delegatesRepo: DelegatesRepositoryFactory.make())
    }
}
