//
//  CampaignsRemoteApiFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 21/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class CampaignsRemoteApiFactory {
    static func make() -> ICampaignsRemoteApi {
        return CampaignsRemoteApi(apiController: ApiController.shared,
                                  dataToCampaignFactory: DataToCampaignFactory()
        )
    }
}
