//
//  RoomRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 25/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RealmSwift

protocol IRoomRepository {
    func getRoom(id: Int) -> IRoom?
    func getAllRooms() -> [IRoom]
    func save(rooms: [IRoom])
}

class RoomRepository: IRoomRepository {
    func getRoom(id: Int) -> IRoom? {
        let realm = try! Realm()
        guard let rRoom = realm.object(ofType: RealmRoom.self, forPrimaryKey: id) else {
            return nil
        }
        return Room(from: rRoom)
    }
    
    func getAllRooms() -> [IRoom] {
        let realm = try! Realm()
        let rRooms = realm.objects(RealmRoom.self).toArray()
        return rRooms.map(Room.init)
    }
    
    func save(rooms: [IRoom]) {
        let realm = try! Realm()
        let rRooms = rooms.map { (room) -> RealmRoom in
            let rRoom = RealmRoom()
            rRoom.updateWith(room: room)
            return rRoom
        }
        try? realm.write {
            realm.add(rRooms, update: .modified)
        }
    }
}
