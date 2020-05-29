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
        campaignsImmRepo.obsGetAll().map(CampaignItemsFactory.make)
    }
    func refreshCampaigns() {
//        campaignsWorker.fetchCampaigns().debounce(1, scheduler: MainScheduler.instance)
//            .subscribe(onError: errorHandler.handle)
//            .disposed(by: bag)
        campaignsWorker.fetchCampaigns().debounce(RxTimeInterval.seconds(1),
                                                  scheduler: MainScheduler.instance)
            .subscribe(onError: errorHandler.handle)
            .disposed(by: bag)
    }
    func campaignSelected(campaignItem: ICampaignItem) {
        if campaignSelectionRepo.getSelected()?.getCampaignId() != campaignItem.id {
            self.campaignResourcesRepo.deleteResources()
        }
        campaignSelectionRepo.userSelected(campaignItem: campaignItem)
    }
}

class CampaignsViewModel {
    private let campaignsImmRepo: ICampaignsImmutableRepository
    private let campaignResourcesRepo: IMutableCampaignResourcesRepository
    private let campaignSelectionRepo: ICampaignSelectionRepository
    private let campaignsWorker: ICampaignsWorker
    private let errorHandler: IErrorHandler
    private let bag = DisposeBag()
    init(campaignsRepository: ICampaignsImmutableRepository,
         campaignResourcesRepo: IMutableCampaignResourcesRepository,
         campaignSelectionRepo: ICampaignSelectionRepository,
         campaignsWorker: ICampaignsWorker,
         errorHandler: IErrorHandler = ErrorHandler()) {
        self.campaignsImmRepo = campaignsRepository
        self.campaignResourcesRepo = campaignResourcesRepo
        self.campaignSelectionRepo = campaignSelectionRepo
        self.campaignsWorker = campaignsWorker
        self.errorHandler = errorHandler
    }
    deinit {
        print("CampaignsViewModel.deinit")
    }
}
