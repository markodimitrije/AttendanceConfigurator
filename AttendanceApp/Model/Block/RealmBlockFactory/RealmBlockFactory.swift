//
//  RealmBlockFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 26/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RealmSwift

class RealmBlockFactory {
    static func make(block: IBlock) -> RealmBlock {
        let rBlock = RealmBlock()
        rBlock.id = block.getId()
        rBlock.name = block.getName()
        rBlock.location_id = block.getLocationId()
        rBlock.starts_at = block.getStartsAt()
        rBlock.ends_at = block.getEndsAt()
        rBlock.closed = block.getClosed()
        return rBlock
    }
}
