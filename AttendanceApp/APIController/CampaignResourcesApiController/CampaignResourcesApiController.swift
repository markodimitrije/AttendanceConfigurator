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
    
    let ematerialsUrl = URL(string: "https://service.e-materials.com/")!
    
    private let apiController: ApiController!
    private let unziper: IUnziper!
    private let resourcesFactory: ICampaignResourcesFromDataFactory
    
    private let bag = DisposeBag()

    private var conferenceId: Int {
        return 7520 // hard-coded TODO: implement me
    }
    
    private var campaignId: Int {
        return 123456 // hard-coded TODO: implement me
    }
 
    init(apiController: ApiController, unziper: IUnziper, resourcesFactory: ICampaignResourcesFromDataFactory) {
     
        self.apiController = apiController
        self.unziper = unziper
        self.resourcesFactory = resourcesFactory
        Logging.URLRequests = { request in return true }
    }

 //MARK: - API Calls
    
    func fetch() -> Observable<ICampaignResources> {
//        return
//            apiController
//            .buildRequest(base: Domain.ematerialsUrl,
//                          method: "GET",
//                          pathComponent: "data/attendance/" + "\(conferenceId)" + "\(campaignId)" + ".zip",
//                          params: [])
        return
            apiController // hard-coded
            .buildRequest(base: ematerialsUrl,
                          method: "GET",
                          pathComponent: "data/attendance/" + "\(conferenceId)" + ".zip",
                          params: [])
                .flatMap(unziper.saveDataAsFile)
                .flatMap(unziper.unzipData)
                .map(resourcesFactory.make)
    }

}
