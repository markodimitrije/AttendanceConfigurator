//
//  ICampaignsViewModel.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

protocol ICampaignsViewModel {
    func getCampaigns() -> Observable<[ICampaignItem]>
}
