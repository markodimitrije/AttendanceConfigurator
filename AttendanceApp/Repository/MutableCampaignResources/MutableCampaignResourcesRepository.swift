//
//  MutableCampaignResourcesRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 29/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

extension MutableCampaignResourcesRepository: IMutableCampaignResourcesRepository {
    func deleteResources() {
        roomsRepo.deleteAllRooms()
        blocksRepo.deleteAllBlocks()
        _ = delegatesRepo.deleteAllDelegates()
    }
}
