//
//  CampaignsWorkerFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 21/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class CampaignsWorkerFactory {
    static func make() -> ICampaignsWorker {
        let remoteApi = CampaignsRemoteApiFactory.make()
        let campaignsRepo = CampaignsRepositoryFactory.make()
        return CampaignsWorker(remoteApi: remoteApi, campaignsRepo: campaignsRepo)
    }
}

class DownloadImageApiFactory {
    static func make() -> IDownloadImageAPI {
        DownloadImageAPI(apiController: ApiController.shared)
    }
}
