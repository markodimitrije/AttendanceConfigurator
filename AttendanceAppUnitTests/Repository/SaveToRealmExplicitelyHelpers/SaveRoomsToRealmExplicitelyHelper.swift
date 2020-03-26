//
//  SaveRoomsToRealmExplicitelyHelper.swift
//  AttendanceAppUnitTests
//
//  Created by Marko Dimitrijevic on 26/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RealmSwift
@testable import AttendanceApp

class SaveRoomsToRealmExplicitelyHelper {
    static func save(rooms: [IRoom]) {
        let rRooms = rooms.map { iRoom -> RealmRoom in
            let rRoom = RealmRoom()
            rRoom.id = iRoom.getId()
            rRoom.name = iRoom.getName()
            rRoom.order = iRoom.getOrder()
            return rRoom
        }
        let realm = try! Realm()
        try! realm.write {
            realm.add(rRooms)
        }
    }
}
