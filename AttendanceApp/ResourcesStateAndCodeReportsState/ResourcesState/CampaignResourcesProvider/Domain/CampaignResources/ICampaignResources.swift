//
//  ICampaignResources.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 27/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

protocol ICampaignResources {
    func getCampaignId() -> String
    func getConfDataVersionId() -> Int
    func getLocations() -> [IRoom]
    func getBlocks() -> [IBlock]
    func getDelegates() -> [IDelegate]
}
