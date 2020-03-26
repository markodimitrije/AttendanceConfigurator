//
//  RealmRoomFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 26/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RealmSwift

class RealmRoomFactory {
    static func make(room: IRoom) -> RealmRoom {
        let rRoom = RealmRoom()
        rRoom.id = room.getId()
        rRoom.name = room.getName()
        rRoom.order = room.getOrder()
        return rRoom
    }
}
