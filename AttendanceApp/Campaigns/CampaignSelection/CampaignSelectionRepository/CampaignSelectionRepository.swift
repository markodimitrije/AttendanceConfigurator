//
//  CampaignSelectionRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 29/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

extension CampaignSelectionRepository: ICampaignSelectionRepository {
    func userSelected(campaignItem: ICampaignItem?) {
        if campaignItem == nil {
            self.dataAccess.deleteAll()
            self.resourcesRepo.deleteResources()
        }
        self.userDefaults.setValue(campaignItem?.id, forKey: CampaignSelection.campaignIdKEY)
        self.userDefaults.setValue(campaignItem?.confId, forKey: CampaignSelection.conferenceIdKEY)
    }
    func getSelected() -> CampaignSelection? {
        CampaignSelection()
    }
}

class CampaignSelectionRepository {
    private let userDefaults: UserDefaults
    private let dataAccess: DataAccess
    private let resourcesRepo: IMutableCampaignResourcesRepository
    
    init(dataAccess: DataAccess,
         resourcesRepo: IMutableCampaignResourcesRepository,
         userDefaults: UserDefaults = UserDefaults.standard) {
        self.dataAccess = dataAccess
        self.resourcesRepo = resourcesRepo
        self.userDefaults = userDefaults
    }
}
