//
//  CampaignSelectionRepositoryFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 29/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class CampaignSelectionRepositoryFactory { // TODO marko: inline class, use just CampaignSelectionRepository
    static func make() -> ICampaignSelectionRepository {
        return CampaignSelectionRepository()
    }
}
