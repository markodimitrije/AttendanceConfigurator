//
//  ICampaignSettingsRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 19/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

protocol ICampaignSettingsRepository {
    var userSelection: ICampaignSettings {get set}
    var obsCampSettings: Observable<ICampaignSettings> {get} // TODO marko (selection)
    var obsDBCampSettings: Observable<ICampaignSettings> {get} // replace with this ? (DataBase)
    var dbCampSettings: ICampaignSettings {get} // replace with this ? (DataBase)
    func campaignSelected(campaignId: String)
    func deleteActualCampaignSettings()
    func deleteAllCampaignsSettings()
}
