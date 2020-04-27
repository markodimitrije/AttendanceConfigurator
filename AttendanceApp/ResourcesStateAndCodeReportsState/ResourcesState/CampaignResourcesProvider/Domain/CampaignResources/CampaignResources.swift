//
//  CampaignResources.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 27/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

extension CampaignResources: ICampaignResources {
    func getConfDataVersionId() -> Int {self.confDataVersionId}
    func getLocations() -> [IRoom] {self.locations}
    func getSessions() -> [IBlock] {self.sessions}
    func getDelegates() -> [IDelegate] {self.delegates}
}

struct CampaignResources {
    var confDataVersionId: Int
    var locations: [IRoom]
    var sessions: [IBlock]
    var delegates: [IDelegate]
}
