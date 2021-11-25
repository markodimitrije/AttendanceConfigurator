//
//  CampaignsRemoteApi.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 21/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

extension CampaignsRemoteApi: ICampaignsRemoteApi {
    func fetchCampaigns() -> Observable<[ICampaign]> {

        let headers = DefaultHeadersFactory.make().createHeaders(apiKey: nil)
        let ematerialsUrl = URL(string: "https://service.e-materials.com/")!
        return apiController
            .buildRequest(base: ematerialsUrl,
                          pathComponent: "api/attendances/campaigns/mine",
                          headers: headers)
            .map(dataToCampaignFactory.make)
    }
}

struct CampaignsRemoteApi {
    private let apiController: ApiController
    private let dataToCampaignFactory: IDataToCampaignFactory
    init(apiController: ApiController, dataToCampaignFactory: IDataToCampaignFactory) {
        self.apiController = apiController
        self.dataToCampaignFactory = dataToCampaignFactory
    }
}
