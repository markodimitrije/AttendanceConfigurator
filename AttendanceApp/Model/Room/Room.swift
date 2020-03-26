//
//  Room.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 22/10/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

protocol IRoom {
    func getId() -> Int
    func getOrder() -> Int
    func getName() -> String
}

class Rooms: Codable {
    var data: [Room]
}

extension Room: IRoom {
    func getId() -> Int {self.id}
    func getOrder() -> Int {self.order}
    func getName() -> String {self.name}
}

class Room: Codable {
    var id: Int
    var name: String
    var order: Int
    init(from realRoom: RealmRoom) {
        self.id = realRoom.id
        self.name = realRoom.name
        self.order = realRoom.order
    }
}

class RealmRoom: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var order: Int = -1
    
    func updateWith(room: IRoom) {
        self.id = room.getId()
        self.name = room.getName()
        self.order = room.getOrder()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func getRoom(withId id: Int, withRealm realm: Realm) -> RealmRoom? {
        
        return realm.objects(RealmRoom.self).filter("id = %@", id).first
    }
    
}
