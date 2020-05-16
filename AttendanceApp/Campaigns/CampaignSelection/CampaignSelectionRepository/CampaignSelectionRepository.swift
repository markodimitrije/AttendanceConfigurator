//
//  CampaignSelectionRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 29/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

extension CampaignSelectionRepository: ICampaignSelectionRepository {
    func userSelected(campaignItem: ICampaignItem) {
        self.userDefaults.setValue(campaignItem.id, forKey: CampaignSelection.campaignIdKEY)
        self.userDefaults.setValue(campaignItem.confId, forKey: CampaignSelection.conferenceIdKEY)
    }
    func getSelected() -> CampaignSelection? {
        CampaignSelection()
    }
}

class CampaignSelectionRepository {
    private let userDefaults: UserDefaults
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
}
