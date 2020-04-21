//
//  CampaignsViewModelFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 20/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class CampaignsViewModelFactory {
    static func make() -> CampaignsViewModel {
        let campaignsRepo = CampaignsRepositoryMock() // TODO marko.. change later with factory 
        let campaignsWorker = CampaignsWorkerFactory.make()
        return CampaignsViewModel(campaignsRepository: campaignsRepo,
                                  campaignsWorker: campaignsWorker)
    }
}
