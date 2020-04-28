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
        return CampaignResourcesWorker(resourcesApiController: remoteApi,
                                       roomsRepo: RoomRepository(),
                                       blocksRepo: BlockMutableRepositoryFactory.make(),
                                       delegatesRepo: DelegatesRepositoryFactory.make())
    }
}
