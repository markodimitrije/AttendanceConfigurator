//
//  ICampaignsRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

protocol ICampaignsMutableRepository {
    func save(campaigns: [ICampaign]) -> Observable<[ICampaign]>
    func deleteAll()
}

protocol ICampaignsImmutableRepository {
    func getAll() -> Observable<[ICampaign]>
}

protocol ICampaignsRepository: ICampaignsMutableRepository, ICampaignsImmutableRepository {}
