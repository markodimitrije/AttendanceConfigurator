//
//  CampaignResourcesFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 27/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class CampaignResourcesFactory: ICampaignResourcesFromDataFactory {
    func make(data: DataProtocol) -> ICampaignResources {
        // hard-coded
        //let data = JsonBundleDataProvider().jsonData(filename: "Resources", inBundle: Bundle.main)
        let campaignId = CampaignSelectionRepositoryFactory.make().getSelected()!.getCampaignId()
        let data = JsonBundleDataProvider().jsonData(filename: "ResourcesForScan" + campaignId,
                                                     inBundle: Bundle.main)
        return try! MyCampaignResourcesFactory.make(data: data) // TODO marko: should handle errors
    }
}

class MyCampaignResourcesFactory {
    static func make(data: Data) throws -> ICampaignResources {
        let dictionary = try DataToDictFactory.make(data: data)
        guard let campaignId = dictionary["campaign_id"] as? String,
            let confDataVersionId = dictionary["conference_data_version_id"] as? Int,
            let locDicts = dictionary["locations"] as? [[String: Any]],
            let tsDicts = dictionary["timeslot_distributions"] as? [[String: Any]],
            let delDicts = dictionary["delegates"] as? [[String: Any]] else {
                throw ApiError.invalidJson
        }
        return CampaignResources(campaignId: campaignId,
                                 confDataVersionId: confDataVersionId,
                                 locations: locDicts.compactMap(RoomFactory.make),
                                 blocks: tsDicts.compactMap(BlockFactory.make),
                                 delegates: delDicts.compactMap(DelegateFactory.make))

    }
    static func make(rResources: RealmCampaignResources) -> ICampaignResources {
        CampaignResources(campaignId: rResources.id,
                          confDataVersionId: rResources.confDataVersion,
                          locations: rResources.rooms.map(RoomFactory.make),
                          blocks: rResources.blocks.map(BlockFactory.make),
                          delegates: rResources.delegates.map(DelegateFactory.make))
    }
}

protocol DataProtocol {}
extension Data: DataProtocol {}
