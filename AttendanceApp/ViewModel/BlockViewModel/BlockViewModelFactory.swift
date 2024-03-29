//
//  BlockViewModelFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 03/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class BlockViewModelFactory {
    static func make(roomId: Int, date: Date?) -> BlockViewModel {
        let blockRepo = BlockImmutableRepositoryFactory.make()
        return BlockViewModel(roomId: roomId,
                              date: date,
                              blockRepository: blockRepo,
                              mostRecentBlockUtility: MostRecentBlockUtility())
    }
}
