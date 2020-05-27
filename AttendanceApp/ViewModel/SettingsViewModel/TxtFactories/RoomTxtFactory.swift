//
//  RoomTxtFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 27/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

protocol IRoomTxtFactory {
    func getText(roomId: Int?) -> String
}

struct RoomTxtFactory: IRoomTxtFactory {
    let roomRepo: IRoomRepository
    func getText(roomId: Int?) -> String {
        if let roomId = roomId {
            return roomRepo.getRoom(id: roomId)?.getName() ?? ""
        } else {
            return RoomTextData.selectRoom
        }
    }
}
