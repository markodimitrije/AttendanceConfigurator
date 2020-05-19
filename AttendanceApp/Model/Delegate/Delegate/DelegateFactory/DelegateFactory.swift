//
//  DelegateFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 11/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxRealm

class DelegateFactory {
    static func make(from json: [String: Any]) -> IDelegate? {
        guard
            let code = json["code"] as? String,
            let tds = json["td"] as? [Int] else {
                return nil
        }
        return Delegate(c: code, s: tds)
    }
    static func make(from rDelegate: RealmDelegate) -> IDelegate {
        return Delegate(c: rDelegate.code,
                        s: rDelegate.blockIds.toArray())
    }
}
