//
//  MostRecentBlockUtility.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 03/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

protocol IMostRecentBlockUtility {
    func getMostRecentBlock(blocksSortedByDate: [IBlock]) -> IBlock?
}

class MostRecentBlockUtility: IMostRecentBlockUtility {
    
    func getMostRecentBlock(blocksSortedByDate: [IBlock]) -> IBlock? {
        
        let todayBlocks = blocksSortedByDate.filter {
            return Calendar.current.compare(Date.now,
                                            to: $0.getStartsAt(),
                                            toGranularity: Calendar.Component.day) == ComparisonResult.orderedSame
        }
        
        let actualOrNextInFiftheenMinutes =
            todayBlocks.filter { block -> Bool in
                let startsAt = block.getStartsAt()
                return startsAt.addingTimeInterval(-MyTimeInterval.waitToMostRecentBlock) < Date.now
            }.last
        
        return actualOrNextInFiftheenMinutes
    }
}
