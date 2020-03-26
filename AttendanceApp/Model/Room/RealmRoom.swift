//
//  RealmRoom.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 26/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RealmSwift

class RealmRoom: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var order: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func getRoom(withId id: Int, withRealm realm: Realm) -> RealmRoom? {
        
        return realm.objects(RealmRoom.self).filter("id = %@", id).first
    }
    
}
