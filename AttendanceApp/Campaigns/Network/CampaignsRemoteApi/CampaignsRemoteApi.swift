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
        //https://staging.e-materials.com/api/attendances/campaigns/mine
        let mockUrl = URL(string:
            "https://bff3365d-8e5a-4f02-b824-8da11ce37caf.mock.pstmn.io/campaigns/4")!
        let headers = DefaultHeadersFactory.make().createHeaders(apiKey: nil)
        
        return apiController
            .buildRequest(base: URL(string: "https://staging.e-materials.com/api/")!,
                          pathComponent: "attendances/campaigns/mine",
                          headers: headers)
//        .buildRequest(base: mockUrl, headers: headers)
            .map(dataToCampaignFactory.make)
        
//        return apiController
//            .buildRequest(pathComponent: "attendances/campaigns/mine", headers: headers)
////        .buildRequest(base: mockUrl, headers: headers)
//            .map(dataToCampaignFactory.make)
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
