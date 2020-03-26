//
//  RoomFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 26/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class RoomFactory {
    static func make(from json: [String: Any]) -> IRoom? {
        guard let id = json["id"] as? Int,
            let name = json["name"] as? String,
            let order = json["order"] as? Int else {
                return nil
        }
        return Room(id: id, name: name, order: order)
    }
    static func make(from realmRoom: RealmRoom) -> IRoom {
        return Room(id: realmRoom.id, name: realmRoom.name, order: realmRoom.order)
    }
}
