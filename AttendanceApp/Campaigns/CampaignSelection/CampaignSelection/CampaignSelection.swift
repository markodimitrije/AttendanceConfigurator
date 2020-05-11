//
//  CampaignSelection.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 29/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

extension CampaignSelection: ICampaignSelection {
    func getCampaignId() -> String {self.campaignId}
    func getConferenceId() -> String {self.conferenceId}
}

struct CampaignSelection {
    static var campaignIdKEY = "campaignId"
    static var conferenceIdKEY = "conferenceId"
    
    private var campaignId: String
    private var conferenceId: String
    init?(userDefaults: UserDefaults = UserDefaults.standard) {
        guard let campaignId = userDefaults.value(forKey: Self.campaignIdKEY) as? String,
            let conferenceId = userDefaults.value(forKey: Self.conferenceIdKEY) as? String else {
                return nil
        }
        self.campaignId = campaignId
        self.conferenceId = conferenceId
    }
}
