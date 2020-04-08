//
//  AutoSessionViewModelFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 08/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class AutoSessionViewModelFactory {
    static func make(roomId: Int, date: Date?) -> AutoSessionViewModel {
        let blockViewModel = BlockViewModelFactory.make(roomId: roomId, date: date)
        return AutoSessionViewModel(blockViewModel: blockViewModel)
    }
}
