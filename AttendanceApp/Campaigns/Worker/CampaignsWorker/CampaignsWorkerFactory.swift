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
        let logoWorker = CampaignLogosWorkerFactory.make()
        return CampaignsWorker(remoteApi: remoteApi,
                               campaignsRepo: campaignsRepo,
                               logoWorker: logoWorker)
    }
}

class CampaignLogosWorkerFactory {
    static func make() -> CampaignLogosWorker {
        let remoteApi = DownloadImageApiFactory.make()
        let repository = CampaignsRepositoryFactory.make()
        return CampaignLogosWorker(campaignsRepo: repository, downloadImageApi: remoteApi)
    }
}

class DownloadImageApiFactory {
    static func make() -> IDownloadImageAPI {
        DownloadImageAPI(apiController: ApiController.shared)
    }
}
