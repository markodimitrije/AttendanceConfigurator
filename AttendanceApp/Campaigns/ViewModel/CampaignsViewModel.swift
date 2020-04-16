//
//  CampaignsViewModel.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//


import RxSwift

extension CampaignsViewModel: ICampaignsViewModel {
    func getItems() -> Observable<[ICampaign]> {
        campaignsRepo.getAll()
    }
}

class CampaignsViewModel {
    
    private let campaignsRepo: ICampaignsRepository
    init(campaignsRepo: ICampaignsRepository) {
        self.campaignsRepo = campaignsRepo
    }
}
