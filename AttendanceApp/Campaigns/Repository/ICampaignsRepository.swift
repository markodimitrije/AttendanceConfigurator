//
//  ICampaignsRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

protocol ICampaignsRepository {
    func save(campaigns: [ICampaign])
    func deleteAll()
    func getAll() -> Observable<[ICampaign]>
}
