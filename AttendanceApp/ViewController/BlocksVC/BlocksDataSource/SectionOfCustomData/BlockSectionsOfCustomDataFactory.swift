//
//  BlockSectionsOfCustomDataFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 08/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class BlockSectionsOfCustomDataFactory {
    static func make(blockSections groups: [[IBlock]], onDate date: Date?) -> [SectionOfCustomData] {
        let sections = groups.map { (blocks) -> SectionOfCustomData in
            let groupName = sectionName(blocks: blocks, date: date)
            let items = blocks.map(BlockCustomDataItemFactory.make)
            return SectionOfCustomData(header: groupName, items: items)
        }
        return sections
    }
    private static func sectionName(blocks: [IBlock], date: Date?) -> String {
        let shortFormat = Date.shortDateFormatString
        if blocks.isEmpty {
            return date?.toString(format: shortFormat) ?? ""
        }
        return blocks.first!.getStartsAt().toString(format: shortFormat)!
    }
}
