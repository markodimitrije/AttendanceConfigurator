//
//  RoomTxtCalculator.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 27/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

protocol IRoomTxtCalculator {
    func getText(roomId: Int?) -> String
}

struct RoomTxtCalculator: IRoomTxtCalculator {
    let roomRepo: IRoomRepository
    func getText(roomId: Int?) -> String {
        if let roomId = roomId {
            return roomRepo.getRoom(id: roomId)?.getName() ?? ""
        } else {
            return RoomTextData.selectRoom
        }
    }
}
