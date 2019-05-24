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
    @objc dynamic var code: String = ""
    
    func updateWith(delegate: Delegate) {
        self.code = delegate.code
    }
    
    override static func primaryKey() -> String? {
        return "code"
    }
    
    static func delegateExists(withCode code: String, withRealm realm: Realm) -> Bool {
        return realm.objects(RealmDelegate.self).filter("code = %@", code).first != nil
    }
    
}
