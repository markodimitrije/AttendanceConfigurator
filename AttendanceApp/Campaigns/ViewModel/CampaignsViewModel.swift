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
}

class CampaignsViewModel {
    var campaignsRepository: ICampaignsImmutableRepository
    init(campaignsRepository: ICampaignsImmutableRepository) {
        self.campaignsRepository = campaignsRepository
    }
}

class CampaignItemsFactory {
    static func make(campaigns: [ICampaign]) -> [ICampaignItem] {
        campaigns.map(self.singleItem)
        
    }
    
    static func singleItem(campaign: ICampaign) -> ICampaignItem {
        CampaignItem(title: campaign.name,
                     description: campaign.description,
                     image: campaign.image)
    }
    
}
