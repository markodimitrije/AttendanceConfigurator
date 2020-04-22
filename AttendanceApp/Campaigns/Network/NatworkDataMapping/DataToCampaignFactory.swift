//
//  DataToCampaignFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 21/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

protocol IDataToCampaignFactory {
    func make(data: Data) throws -> [ICampaign]
}

class DataToCampaignFactory: IDataToCampaignFactory {
    func make(data: Data) throws -> [ICampaign] {
        do {
            guard let json = try? JSONSerialization.jsonObject(with: data),
                let dict = json as? [String: Any],
                let campaignsArr = dict["data"] as? [[String: Any]] else {
                    throw CampaignsError.unreadable
            }
            return campaignsArr.compactMap(self.singleCampaignFactory)
        } catch {
            throw CampaignsError.unreadable
        }
    }
    
    private func singleCampaignFactory(dict: [String: Any]) -> ICampaign? {
        guard let id = dict["id"] as? Int,
            let name = dict["name"] as? String,
            let description = dict["description"] as? String,
            let logo = dict["logo"] as? String,
            let created_at = dict["created_at"] as? String,
            let createdAt = created_at.toDate(format: Date.defaultFormatString)
        else {
            return nil
        }
        return Campaign(id: "\(id)", name: name, description: description, logo: logo, createdAt: createdAt, image: nil)
    }
}
