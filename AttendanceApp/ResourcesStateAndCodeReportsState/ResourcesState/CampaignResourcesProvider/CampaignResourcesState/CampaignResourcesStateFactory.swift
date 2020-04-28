//
//  CampaignResourcesStateFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 28/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class CampaignResourcesStateFactory {
    static func make() -> IResourcesState {
        let worker = CampaignResourcesWorkerFactory.make()
        return CampaignResourcesState(campaignResourcesWorker: worker)
    }
}
