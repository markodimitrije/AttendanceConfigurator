//
//  RealmBlockFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 26/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RealmSwift

class RealmBlockFactory {
    static func make(block: IBlock, realm: Realm = try! Realm.init()) -> RealmBlock {
        let rBlock = RealmBlock()
        rBlock.updateWith(block: block, withRealm: realm)
        return rBlock
    }
}
