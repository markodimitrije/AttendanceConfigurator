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
              let location_id = json["location_id"] as? Int,
              let starts_at = json["starts_at"] as? String,
              let ends_at = json["ends_at"] as? String,
              let startsAt = starts_at.toDate(format: Date.defaultFormatString),
              let endsAt = ends_at.toDate(format: Date.defaultFormatString) else {
                return nil
        }
        let closed = json["closed"] as? Bool ?? false
        let name = json["default_title"] as? String ?? "session"
        
        return Block(id: id,
                     location_id: location_id,
                     name: name,
                     starts_at: startsAt,
                     ends_at: endsAt,
                     closed: closed)
    }
    static func make(from realmBlock: RealmBlock) -> IBlock {
        return Block(id: realmBlock.id,
                     location_id: realmBlock.location_id,
                     name: realmBlock.name,
                     starts_at: realmBlock.starts_at,
                     ends_at: realmBlock.ends_at,
                     closed: realmBlock.closed)
    }
}
