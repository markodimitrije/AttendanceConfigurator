//
//  CampaignResourcesFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 27/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class CampaignResourcesFactory: ICampaignResourcesFromDataFactory {
    func make(data: Data) -> ICampaignResources {
        CampaignResourcesEmptyMock()
    }
}

class CampaignResourcesEmptyMock: ICampaignResources {
    
    func getConfDataVersionId() -> Int { 1 }
    
    func getLocations() -> [IRoom] {
        RoomsFromJsonFileLoader.make(filename: "Rooms")
    }
    
    func getSessions() -> [IBlock] {
        BlocksFromJsonFileLoader.make(filename: "Blocks")
    }
    
    func getDelegates() -> [IDelegate] {
        let delA = Delegate(c: "000001", s: [1000, 1001, 1002])
        let delB = Delegate(c: "000002", s: [1003, 1004, 1005])
        let delC = Delegate(c: "000003", s: [1000, 1003, 1008])
        return [delA, delB, delC]
    }
    
}
