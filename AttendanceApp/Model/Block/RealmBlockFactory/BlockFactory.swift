//
//  BlockFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 26/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class BlockFactory {
    static func make(from json: [String: Any]) -> IBlock? {
        guard let id = json["id"] as? Int,
            let name = json["name"] as? String,
            let location_id = json["location_id"] as? Int,
            let starts_at = json["starts_at"] as? String,
            let ends_at = json["ends_at"] as? String,
            let startsAt = starts_at.toDate(format: Date.defaultFormatString),
            let endsAt = ends_at.toDate(format: Date.defaultFormatString),
            let closed = json["closed"] as? Bool else {
                return nil
        }
        
        return Block(id: id,
                     name: name,
                     location_id: location_id,
                     starts_at: startsAt,
                     ends_at: endsAt,
                     closed: closed)
    }
    static func make(from realmBlock: RealmBlock) -> IBlock {
        return Block(id: realmBlock.id,
                     name: realmBlock.name,
                     location_id: realmBlock.location_id,
                     starts_at: realmBlock.starts_at,
                     ends_at: realmBlock.ends_at,
                     closed: realmBlock.closed)
    }
}
