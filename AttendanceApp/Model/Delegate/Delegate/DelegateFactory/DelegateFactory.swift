//
//  DelegateFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 11/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class DelegateFactory {
    static func make(from json: [String: Any]) -> IDelegate? {
        guard let id = json["id"] as? Int,
            let code = json["code"] as? String,
            let tds = json["td"] as? [Int] else {
                return nil
        }
        return Delegate(id: id, c: code, s: tds)
    }
    static func make(from rDelegate: RealmDelegate) -> IDelegate {
        return Delegate(id: rDelegate.id,
                        c: rDelegate.code,
                        s: rDelegate.blockIds.toArray())
    }
}
