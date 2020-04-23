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
        guard let id = dict["id"] as? String,
            let name = dict["name"] as? String,
            let conferenceId = dict["conference_id"] as? Int,
            let restrictedAccess = dict["restricted_access"] as? Bool,
            let created_at = dict["created_at"] as? String,
            let createdAt = created_at.toDate(format: Date.defaultFormatString)
        else {
            return nil
        }
        
        var updatedAt: Date?
        var deletedAt: Date?
        if let updated_at = dict["updated_at"] as? String {
            updatedAt = updated_at.toDate(format: Date.defaultFormatString)
        }
        if let deleted_at = dict["deleted_at"] as? String {
            deletedAt = deleted_at.toDate(format: Date.defaultFormatString)
        }
        
        return Campaign(id: id,
                        name: name,
                        description: dict["description"] as? String,
                        logo: dict["logo"] as? String,
                        conferenceId: conferenceId,
                        restrictedAccess: restrictedAccess,
                        createdAt: createdAt,
                        updatedAt: updatedAt,
                        deletedAt: deletedAt,
                        image: nil)
    }
}
