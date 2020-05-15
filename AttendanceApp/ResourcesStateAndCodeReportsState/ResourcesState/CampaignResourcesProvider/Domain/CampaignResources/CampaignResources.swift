//
//  CampaignResources.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 27/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

extension CampaignResources: ICampaignResources {
    func getCampaignId() -> String {self.campaignId}
    func getConfDataVersionId() -> Int {self.confDataVersionId}
    func getLocations() -> [IRoom] {self.locations}
    func getBlocks() -> [IBlock] {self.blocks}
    func getDelegates() -> [IDelegate] {self.delegates}
}

struct CampaignResources {
    let campaignId: String
    let confDataVersionId: Int
    let locations: [IRoom]
    let blocks: [IBlock]
    let delegates: [IDelegate]
}

class DataToDictFactory { // TODO marko: pronblem with removing to its own file !!??
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
