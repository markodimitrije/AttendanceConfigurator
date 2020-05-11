//
//  RealmDelegate.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 24/05/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class RealmDelegate: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var code: String = ""
    let sessionIds = List<Int>()
    
    func updateWith(delegate: IDelegate) {
        self.id = delegate.getId()
        self.code = delegate.getCode()
        self.sessionIds.removeAll()
        self.sessionIds.append(objectsIn: delegate.sessionIds())
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
