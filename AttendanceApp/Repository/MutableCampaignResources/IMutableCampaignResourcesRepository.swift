//
//  IMutableCampaignResourcesRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 29/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

protocol IMutableCampaignResourcesRepository {
    func deleteResources()
}

class MutableCampaignResourcesRepositoryFactory {
    static func make() -> IMutableCampaignResourcesRepository {
        return MutableCampaignResourcesRepository(
            roomsRepo: RoomRepository(),
            blocksRepo: BlockMutableRepositoryFactory.make(),
            delegatesRepo: DelegatesRepositoryFactory.make())
    }
}
