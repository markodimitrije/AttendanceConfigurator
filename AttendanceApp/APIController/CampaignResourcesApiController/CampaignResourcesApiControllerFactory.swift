//
//  CampaignResourcesApiControllerFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 27/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class CampaignResourcesApiControllerFactory {
    static func make() -> ICampaignResourcesApiController {
        guard let confId = CampaignSelectionRepository().getSelected()?.getConferenceId(),
              let conferenceId = Int(confId) else {
            fatalError("how can you ask for campaign resources if campaign not selected !!?")
        }
        let apiController = ApiController.shared
        let unziper = Unziper(conferenceId: conferenceId)
        let campaignSelection = CampaignSelectionRepositoryFactory.make().getSelected()
        return CampaignResourcesApiController(apiController: apiController,
                                              unziper: unziper,
                                              resourcesFactory: CampaignResourcesFactory(),
                                              campaignSelection: campaignSelection!)
        // hard-coded: for testing.. mock data
//        return MockCampaignResourcesApiController(apiController: apiController,
//                                                  resourcesFactory: CampaignResourcesFactory(),
//                                                  campaignSelection: campaignSelection!)
    }
}
