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
    func getLogoUpdateInfos() -> [ILogoUpdateInfo]
}

protocol ICampaignsRepository: ICampaignsMutableRepository, ICampaignsImmutableRepository {}

protocol ILogoUpdateInfo {
    var id: Int {get}
    var url: URL {get}
}

struct LogoUpdateInfo: ILogoUpdateInfo {
    var id: Int
    var url: URL
    init?(id: Int, address: String) {
        guard let url = URL(string: address) else {
            return nil
        }
        self.id = id
        self.url = url
    }
}
