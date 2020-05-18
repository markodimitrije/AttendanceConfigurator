//
//  CampaignsViewModel.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//


import RxSwift

extension CampaignsViewModel: ICampaignsViewModel{
    func getCampaigns() -> Observable<[ICampaignItem]> {
        campaignsRepository.obsGetAll().map(CampaignItemsFactory.make)
    }
    func refreshCampaigns() {
//        campaignsWorker.fetchCampaigns().debounce(1, scheduler: MainScheduler.instance)
//            .subscribe(onError: errorHandler.handle)
//            .disposed(by: bag)
        campaignsWorker.fetchCampaigns().debounce(1, scheduler: MainScheduler.instance)
            .subscribe(onError: errorHandler.handle)
            .disposed(by: bag)
    }
}

class CampaignsViewModel {
    private let campaignsRepository: ICampaignsImmutableRepository
    private let campaignsWorker: ICampaignsWorker
    private let errorHandler: IErrorHandler
    private let bag = DisposeBag()
    init(campaignsRepository: ICampaignsImmutableRepository,
         campaignsWorker: ICampaignsWorker,
         errorHandler: IErrorHandler = ErrorHandler()) {
        self.campaignsRepository = campaignsRepository
        self.campaignsWorker = campaignsWorker
        self.errorHandler = errorHandler
    }
    deinit {
        print("CampaignsViewModel.deinit")
    }
}
