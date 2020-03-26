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
            rBlock.id = iBlock.getId()
            rBlock.name = iBlock.getName()
            rBlock.location_id = iBlock.getLocationId()
            rBlock.starts_at = iBlock.get_Starts_At()
            rBlock.ends_at = iBlock.get_Ends_At()
            rBlock.closed = iBlock.getClosed()
            return rBlock
        }
        try! realm.write {
            realm.add(rBlock)
        }
    }
}
