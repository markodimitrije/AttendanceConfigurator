//
//  RealmRoomFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 26/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RealmSwift

class RealmRoomFactory {
    static func make(room: IRoom, realm: Realm = try! Realm.init()) -> RealmRoom {
        let rRoom = RealmRoom()
        rRoom.updateWith(room: room)
        return rRoom
    }
}
