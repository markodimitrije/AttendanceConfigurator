//
//  CampaignResourcesApiControllerFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 27/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class CampaignResourcesApiControllerFactory {
    static func make() -> ICampaignResourcesApiController {
        let apiController = ApiController.shared
        let unziper = Unziper(conferenceId: 7520) // hard-coded
        return CampaignResourcesApiController(apiController: apiController,
                                              unziper: unziper,
                                              resourcesFactory: CampaignResourcesFactory())
    }
}
