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
        campaignsRepository.getAll().map(CampaignItemsFactory.make)
    }
    func refreshCampaigns() {
        campaignsWorker.fetchCampaigns()
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
}

class CampaignItemsFactory {
    static func make(campaigns: [ICampaign]) -> [ICampaignItem] {
        campaigns.map(self.singleItem)
        
    }
    
    static func singleItem(campaign: ICampaign) -> ICampaignItem {
        CampaignItem(title: campaign.name,
                     description: campaign.description,
                     image: campaign.image ?? CAMPAIGN_DEF_IMG)
    }
    
}

protocol IErrorHandler {
    func handle(error: Error)
}

extension ErrorHandler: IErrorHandler {
    func handle(error: Error) {
        errorPresenter.showAlert(error: error)
    }
}

class ErrorHandler {
    private let errorPresenter: IAlertErrorPresenter
    init(errorPresenter: IAlertErrorPresenter = AlertErrorPresenter()) {
        self.errorPresenter = errorPresenter
    }
}
