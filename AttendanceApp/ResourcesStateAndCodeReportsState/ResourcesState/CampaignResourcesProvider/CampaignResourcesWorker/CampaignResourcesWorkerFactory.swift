//
//  CampaignResourcesWorkerFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 27/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class CampaignResourcesWorkerFactory {
    static func make() -> ICampaignResourcesWorker {
        let remoteApi = CampaignResourcesApiControllerFactory.make()
        let campaignResourcesRepo = CampaignResourcesRepositoryFactory.make()
        return CampaignResourcesWorker(resourcesApiController: remoteApi,
                                       campaignResourcesRepo: campaignResourcesRepo)
    }
}

class CampaignResourcesRepositoryFactory {
    static func make() -> ICampaignResourcesRepository {
        CampaignResourcesRepository(roomsRepo: RoomRepository(),
                                    blocksRepo: BlockMutableRepositoryFactory.make(),
                                    delegatesRepo: DelegatesRepositoryFactory.make())
    }
}
