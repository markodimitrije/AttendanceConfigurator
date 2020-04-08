//
//  BlocksCustomDataItemFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 08/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class BlocksCustomDataItemFactory {
    static func make(block: IBlock) -> BlocksSectionOfCustomData.Item {
        return BlocksSectionOfCustomData.Item(name: block.getName(), date: block.getStartsAt())
    }
}
