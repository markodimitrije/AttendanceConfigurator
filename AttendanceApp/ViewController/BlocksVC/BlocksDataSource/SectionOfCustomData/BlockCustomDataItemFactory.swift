//
//  BlockCustomDataItemFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 08/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class BlockCustomDataItemFactory {
    static func make(block: IBlock) -> SectionOfCustomData.Item {
        return SectionOfCustomData.Item(name: block.getName(), date: block.getStartsAt())
    }
}
