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
    
    func getLocations() -> [IRoom] {[IRoom]()}
    
    func getSessions() -> [IBlock] {[IBlock]()}
    
    func getDelegates() -> [IDelegate] {[IDelegate]()}
    
}
