//
//  CampaignSelection.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 29/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

extension CampaignSelection: ICampaignSelection {
    func getCampaignId() -> Int {self.campaignId}
    func getConferenceId() -> Int {self.conferenceId}
}

struct CampaignSelection {
    static var campaignIdKEY = "campaignId"
    static var conferenceIdKEY = "conferenceId"
    
    private var campaignId: Int
    private var conferenceId: Int
    init?(userDefaults: UserDefaults = UserDefaults.standard) {
        guard let campaignId = userDefaults.value(forKey: Self.campaignIdKEY) as? Int,
            let conferenceId = userDefaults.value(forKey: Self.conferenceIdKEY) as? Int else {
                return nil
        }
        self.campaignId = campaignId
        self.conferenceId = conferenceId
    }
}
