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
    private let campaignSelection: ICampaignSelection
    
    init(apiController: ApiController, unziper: IUnziper, resourcesFactory: ICampaignResourcesFromDataFactory, campaignSelection: ICampaignSelection) {
     
        self.apiController = apiController
        self.unziper = unziper
        self.resourcesFactory = resourcesFactory
        self.campaignSelection = campaignSelection
        Logging.URLRequests = { request in return false }
    }

 //MARK: - API Calls
    // marko: confId a ne campaignId (dule shit...)
    func fetch() -> Observable<ICampaignResources> {
        let confId = campaignSelection.getConferenceId()
        print("campaignSelection.description = \(campaignSelection.description)")
        
        return
            apiController
            .buildRequest(base: URL(string: "https://service.e-materials.com")!,
                          method: "GET",
                          pathComponent: "data/attendance/" + "\(confId)" + ".zip",
                          params: [])
                .flatMap(unziper.saveDataAsFile)
                .flatMap(unziper.unzipData)
                .map({ (data) -> (data: Data, confId: String) in (data, confId) })
                .map(resourcesFactory.make)
    }

}

class MockCampaignResourcesApiController: ICampaignResourcesApiController {
 //https://service.e-materials.com/data/attendance/CONF_ID/CAMPAIGN_ID.zip
    
    let ematerialsUrl = URL(string: "https://b276c755-37f6-44d2-85af-6f3e654511ad.mock.pstmn.io/")!
    
    private let apiController: ApiController!
    private let resourcesFactory: ICampaignResourcesFromDataFactory
    private let campaignSelection: ICampaignSelection
    
    init(apiController: ApiController, resourcesFactory: ICampaignResourcesFromDataFactory, campaignSelection: ICampaignSelection) {
     
        self.apiController = apiController
        self.resourcesFactory = resourcesFactory
        self.campaignSelection = campaignSelection
        Logging.URLRequests = { request in return false }
    }

 //MARK: - API Calls
    
    func fetch() -> Observable<ICampaignResources> {
        let confId = campaignSelection.getConferenceId()
        print("campaignSelection.description = \(campaignSelection.description)")
        return
            apiController
            .buildRequest(base: ematerialsUrl,
                          method: "GET",
                          pathComponent: "data/attendance/" + "\(confId)" + ".zip",
                          params: [],
//                          timeout: 0.01)
                        timeout: 60)
            .map({ (data) -> (data: Data, confId: String) in (data, confId) })
            .map(resourcesFactory.make)
    }

}
