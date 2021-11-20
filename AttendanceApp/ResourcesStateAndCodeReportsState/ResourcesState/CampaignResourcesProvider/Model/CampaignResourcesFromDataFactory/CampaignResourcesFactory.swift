//
//  CampaignResourcesFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 27/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class CampaignResourcesFactory: ICampaignResourcesFromDataFactory {
    func make(data: Data, confId: String) throws -> ICampaignResources {
        return try CampaignResourcesFactory.make(data: data, confId: confId)
    }
    
    static func make(data: Data, confId: String) throws -> ICampaignResources {
        let dictionary = try DataToDictFactory.make(data: data)
        guard let confDataVersionId = dictionary["conference_data_version_id"] as? Int,
            let locDicts = dictionary["locations"] as? [[String: Any]],
            let tsDicts = dictionary["timeslot_distributions"] as? [[String: Any]],
            let delDicts = dictionary["delegates"] as? [[String: Any]] else {
                throw ApiError.invalidJson
        }
        return CampaignResources(confId: confId,
                                 confDataVersionId: confDataVersionId,
                                 locations: locDicts.compactMap(RoomFactory.make),
                                 blocks: tsDicts.compactMap(BlockFactory.make),
                                 delegates: delDicts.compactMap(DelegateFactory.make))

    }
    static func make(rResources: RealmCampaignResources) -> ICampaignResources {
        CampaignResources(confId: rResources.id,
                          confDataVersionId: rResources.confDataVersion,
                          locations: rResources.rooms.map(RoomFactory.make),
                          blocks: rResources.blocks.map(BlockFactory.make),
                          delegates: rResources.delegates.map(DelegateFactory.make))
    }
}

