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
    func updateLogo(id: String, data: Data)
}

protocol ICampaignsImmutableRepository {
    func getAll() -> Observable<[ICampaign]>
    func getLogoUpdateInfos() -> [ILogoUpdateInfo]
}

protocol ICampaignsRepository: ICampaignsMutableRepository, ICampaignsImmutableRepository {}

protocol ILogoUpdateInfo {
    var id: String {get}
    var url: URL {get}
}

struct LogoUpdateInfo: ILogoUpdateInfo {
    var id: String
    var url: URL
    init?(id: String, address: String) {
        guard let url = URL(string: address) else {
            return nil
        }
        self.id = id
        self.url = url
    }
}
