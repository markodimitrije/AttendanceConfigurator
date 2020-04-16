//
//  CampaignsViewModel.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//


import RxSwift

protocol ICampaignsViewModel {
    func getItems() -> Observable<[ICampaign]>
    func logout()
}

extension CampaignsViewModel: ICampaignsViewModel {
    func getItems() -> Observable<[ICampaign]> {
        campaignsRepo.getAll()
    }
    func logout() {
        
    }
}

class CampaignsViewModel {
    
    private let campaignsRepo: ICampaignsRepository
    private let logoutViewModel: ILogoutViewModel
    
    init(campaignsRepo: ICampaignsRepository, logoutViewModel: ILogoutViewModel) {
        self.campaignsRepo = campaignsRepo
        self.logoutViewModel = logoutViewModel
    }
}
