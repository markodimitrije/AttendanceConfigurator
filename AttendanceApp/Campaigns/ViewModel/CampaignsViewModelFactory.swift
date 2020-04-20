//
//  CampaignsViewModelFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 20/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class CampaignsViewModelFactory {
    static func make() -> CampaignsViewModel {
        let campaignsRepo = CampaignsRepositoryMock() // TODO marko..
        return CampaignsViewModel(campaignsRepository: campaignsRepo)
    }
}
