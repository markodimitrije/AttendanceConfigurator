//
//  File.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 24/05/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class RealmBlock: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var location_id: Int = -1 // ref na location (room)
    @objc dynamic var starts_at: String = ""
    @objc dynamic var ends_at: String = ""
    @objc dynamic var closed: Bool = false
    
    @objc dynamic var owner: RealmRoom?
    
    // rac. var koji ako je "today" vraca starts_at(HH:mm) - ends_at(HH:mm)
    // ako nije onda yyyy-MM-dd (starts_at)HH:mm-(ends_at)HH:mm
    var duration: String {
        
        let timeStartsAt = Date.parseIntoTime(starts_at, outputWithSeconds: false)
        let timeEndsAt = Date.parseIntoTime(ends_at, outputWithSeconds: false)
        
        let calendar = Calendar.init(identifier: .gregorian)
        
        let timeDuration = timeStartsAt + "-" + timeEndsAt
        
        if calendar.isDateInToday(Date.parse(starts_at)) {
            return timeDuration
        } else {
            return Date.parseIntoDateOnly(starts_at) + " " + timeDuration
        }
        
    }
    
    func updateWith(block: Block, withRealm realm: Realm) {
        self.id = block.id
        self.name = block.name
        self.location_id = block.location_id
        self.starts_at = block.starts_at
        self.ends_at = block.ends_at
        self.closed = block.closed
        owner = RealmRoom.getRoom(withId: self.location_id, withRealm: realm)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func getBlock(withId id: Int, withRealm realm: Realm) -> RealmBlock? {
        
        return realm.objects(RealmBlock.self).filter("id = %@", id).first
    }
    
}
