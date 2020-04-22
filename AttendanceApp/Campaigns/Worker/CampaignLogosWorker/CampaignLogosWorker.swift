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
        campaignsLogosArr
            .debug() // TODO marko - implement
            .subscribe(onNext: { info in
                print("imam data za id = \(info.0)")
                self.campaignsRepo.updateLogo(id: info.0, data: info.1)
            }).disposed(by: bag)
    }
}

class CampaignLogosWorker {
    private let campaignsRepo: ICampaignsRepository
    private let downloadImageApi: IDownloadImageAPI
    private let bag = DisposeBag()
    init(campaignsRepo: ICampaignsRepository, downloadImageApi: IDownloadImageAPI) {
        self.campaignsRepo = campaignsRepo
        self.downloadImageApi = downloadImageApi
    }
}
