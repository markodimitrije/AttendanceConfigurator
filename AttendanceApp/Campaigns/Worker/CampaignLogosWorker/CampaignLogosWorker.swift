//
//  CampaignLogosWorker.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 21/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

extension CampaignLogosWorker: ICampaignLogosWorker {
    func fetchLogos() {
        let logoInfos = campaignsRepo.getLogoUpdateInfos()
        let timedLogoUpdateInfos = Observable<Int>.interval(RxTimeInterval(0.01), scheduler: MainScheduler.instance).takeWhile {$0 < logoInfos.count}.map {logoInfos[$0]}
        let campaignsLogosArr = timedLogoUpdateInfos.flatMap { (logoInfo) in
            self.downloadImageApi.fetchImage(url: logoInfo.url).map {(logoInfo.id, $0)}
        }
        campaignsLogosArr // TODO marko - implement
            .subscribe(onNext: { info in
                print("imam data za id = \(info.0)")
            })
    }
}

class CampaignLogosWorker {
    private let campaignsRepo: ICampaignsRepository
    private let downloadImageApi: IDownloadImageAPI
    init(campaignsRepo: ICampaignsRepository, downloadImageApi: IDownloadImageAPI) {
        self.campaignsRepo = campaignsRepo
        self.downloadImageApi = downloadImageApi
    }
}
