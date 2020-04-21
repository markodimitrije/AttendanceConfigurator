//
//  ICampaignsRemoteApi.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 20/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

protocol ICampaignsRemoteApi {
    func getCampaigns() -> Observable<[ICampaign]>
}

