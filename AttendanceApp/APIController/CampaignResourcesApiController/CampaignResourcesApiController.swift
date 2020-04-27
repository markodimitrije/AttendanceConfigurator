//
//  CampaignResourcesApiController.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 27/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift
import RxCocoa

protocol ICampaignResourcesApiController {
    func fetch() -> Observable<ICampaignResources>
}


class CampaignResourcesApiController: ICampaignResourcesApiController {
 //https://service.e-materials.com/data/attendance/CONF_ID/CAMPAIGN_ID.zip
    
    private let apiController: ApiController!
    private let unziper: IUnziper!
    private let resourcesFactory: ICampaignResourcesFromDataFactory
    
    private let bag = DisposeBag()

    struct Domain {
        static let ematerialsUrl = URL(string: "https://service.e-materials.com/data/attendance/")!
//        static let minjonUrl = URL(string: "https://b276c755-37f6-44d2-85af-6f3e654511ad.mock.pstmn.io")!
    }
 
    private var conferenceId: Int {
        return conferenceState.conferenceId ?? 0 // hard-coded
    }
    
    private var campaignId: Int {
        return conferenceState.conferenceId ?? 0 // hard-coded
    }
 
    init(apiController: ApiController, unziper: IUnziper, resourcesFactory: ICampaignResourcesFromDataFactory) {
     
        self.apiController = apiController
        self.unziper = unziper
        self.resourcesFactory = resourcesFactory
        Logging.URLRequests = { request in return true }
    }

 //MARK: - API Calls
    
    func fetch() -> Observable<ICampaignResources> {
        return
            apiController
            .buildRequest(base: Domain.ematerialsUrl,
                          method: "GET",
                          pathComponent: "data/attendance/" + "\(conferenceId)" + "\(campaignId)" + ".zip",
                          params: [])
            .flatMap(unziper.saveDataAsFile)
            .flatMap(unziper.unzipData)
            //.flatMap(convertFrom)
            .map(resourcesFactory.make)
    }

}
