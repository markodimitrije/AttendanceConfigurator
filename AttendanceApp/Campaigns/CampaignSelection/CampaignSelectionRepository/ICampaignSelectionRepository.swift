//
//  ICampaignSelectionRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 29/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

protocol ICampaignSelectionRepository {
    func userSelected(campaignItem: ICampaignItem)
    func getSelected() -> CampaignSelection?
}
