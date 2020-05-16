//
//  RealmCampaignResourcesFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class RealmCampaignResourcesFactory {
    static func make(resources: ICampaignResources) -> RealmCampaignResources {
        
        let rResources = RealmCampaignResources()
        rResources.id = resources.getCampaignId()
        rResources.confDataVersion = resources.getConfDataVersionId()
        
        let rooms = resources.getLocations().map(RealmRoomFactory.make)
        rResources.rooms.insert(contentsOf: rooms, at: 0)
        
        let blocks = resources.getBlocks().map(RealmBlockFactory.make)
        rResources.blocks.insert(contentsOf: blocks, at: 0)
        
        let delegates = resources.getDelegates().map(RealmDelegateFactory.make)
        rResources.delegates.insert(contentsOf: delegates, at: 0)
        
        return rResources
    }
}
