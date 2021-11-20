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
    @objc dynamic var location_id: Int = -1 // ref na location (room)
    @objc dynamic var name: String = ""
    @objc dynamic var starts_at: Date = Date.init(timeIntervalSince1970: 0)
    @objc dynamic var ends_at: Date = Date.init(timeIntervalSince1970: 0)
    @objc dynamic var closed: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
