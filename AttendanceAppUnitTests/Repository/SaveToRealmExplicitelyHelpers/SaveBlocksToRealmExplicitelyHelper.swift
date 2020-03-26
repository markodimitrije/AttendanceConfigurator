//
//  SaveBlocksToRealmExplicitelyHelper.swift
//  AttendanceAppUnitTests
//
//  Created by Marko Dimitrijevic on 26/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RealmSwift
@testable import AttendanceApp

class SaveBlocksToRealmExplicitelyHelper {
    static func save(blocks: [IBlock]) {
        let realm = try! Realm()
        let rBlock = blocks.map { iBlock -> RealmBlock in
            let rBlock = RealmBlock()
            rBlock.updateWith(block: iBlock, withRealm: realm)
            return rBlock
        }
        try! realm.write {
            realm.add(rBlock)
        }
    }
}
