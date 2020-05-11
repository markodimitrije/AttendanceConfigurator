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
    func getBlocks() -> [IBlock] {self.blocks}
    func getDelegates() -> [IDelegate] {self.delegates}
}

struct CampaignResources {
    private let confDataVersionId: Int
    private let locations: [IRoom]
    private let blocks: [IBlock]
    private let delegates: [IDelegate]
    init(data: Data) throws {
        let dictionary = try DataToDictFactory.make(data: data)
        guard let confDataVersionId = dictionary["conference_data_version_id"] as? Int,
            let locDicts = dictionary["locations"] as? [[String: Any]],
            let tsDicts = dictionary["timeslot_distributions"] as? [[String: Any]],
            let delDicts = dictionary["delegates"] as? [[String: Any]] else {
                throw ApiError.invalidJson
        }
        self.locations = locDicts.compactMap(RoomFactory.make)
        self.blocks = tsDicts.compactMap(BlockFactory.make)
        self.delegates = delDicts.compactMap(DelegateFactory.make)
        self.confDataVersionId = confDataVersionId
    }
}

class DataToDictFactory {
    static func make(data: Data) throws -> [String: Any] {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            guard let dictionary = jsonObject as? [String: Any] else {
                throw ApiError.invalidJson
            }
            return dictionary
        } catch let err {
            throw err
        }
    }
}
