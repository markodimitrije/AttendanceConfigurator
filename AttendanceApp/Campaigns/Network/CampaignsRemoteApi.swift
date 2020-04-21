//
//  CampaignsRemoteApi.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 21/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

extension CampaignsRemoteApi: ICampaignsRemoteApi {
    func getCampaigns() -> Observable<[ICampaign]> {
        apiController.buildRequest(pathComponent: "leadlink/campaigns")
            .map(dataToCampaignFactory.make)
    }
}

class CampaignsRemoteApi {
    private let apiController: ApiController
    private let dataToCampaignFactory: IDataToCampaignFactory
    init(apiController: ApiController, dataToCampaignFactory: IDataToCampaignFactory) {
        self.apiController = apiController
        self.dataToCampaignFactory = dataToCampaignFactory
    }
}
