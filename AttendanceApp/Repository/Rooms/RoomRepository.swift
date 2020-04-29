//
//  RoomRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 25/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RealmSwift
import RxSwift

protocol IRoomRepository {
    func getRoom(id: Int) -> IRoom?
    func getAllRooms() -> [IRoom]
    func getObsAllRooms() -> Observable<[IRoom]>
    func save(rooms: [IRoom])
    func replaceExistingWith(rooms: [IRoom])
    func deleteAllRooms()
}

class RoomRepository: IRoomRepository {
    
    private func getRoomResults() -> Results<RealmRoom> {
        let realm = try! Realm()
        return realm.objects(RealmRoom.self).sorted(byKeyPath: "order", ascending: true)
    }
    
    func getRoom(id: Int) -> IRoom? {
        let realm = try! Realm()
        guard let rRoom = realm.object(ofType: RealmRoom.self, forPrimaryKey: id) else {
            return nil
        }
        return RoomFactory.make(from: rRoom)
    }
    
    func getAllRooms() -> [IRoom] {
        let rRooms = getRoomResults().toArray()
        return rRooms.map(RoomFactory.make(from:))
    }
    
    func getObsAllRooms() -> Observable<[IRoom]> {
        let rooms = Observable.collection(from: getRoomResults())
        return rooms.map { (results) -> [IRoom] in
            results.map(RoomFactory.make(from:))
        }
    }
    
    func save(rooms: [IRoom]) {
        let realm = try! Realm()
        let rRooms = rooms.map(RealmRoomFactory.make)
        try? realm.write {
            realm.add(rRooms, update: .modified)
        }
    }
    
    func replaceExistingWith(rooms: [IRoom]) {
        deleteAllRooms()
        save(rooms: rooms)
    }
    
    func deleteAllRooms() {
        let realm = try! Realm()
        let previousRooms = realm.objects(RealmRoom.self)
        try! realm.write {
            realm.delete(previousRooms)
        }
    }
}
