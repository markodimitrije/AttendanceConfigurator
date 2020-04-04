//
//  File.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 24/05/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import Foundation
import RealmSwift

class RealmBlock: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var location_id: Int = -1 // ref na location (room)
    @objc dynamic var starts_at: String = ""
    @objc dynamic var ends_at: String = ""
    @objc dynamic var closed: Bool = false
    
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
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
