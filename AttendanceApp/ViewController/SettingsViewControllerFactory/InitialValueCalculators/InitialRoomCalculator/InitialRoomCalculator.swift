//
//  InitialRoomCalculator.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 28/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

protocol IInitialRoomCalculator {
    func getRoom() -> Int?
}

struct InitialRoomCalculator: IInitialRoomCalculator {
    let settings = ScanSettingsRepositoryFactory.make()
    let roomRepo = RoomRepository()
    func getRoom() -> Int? {
        let savedRoomId = settings.getScanSettings().roomId
        var room: Int?
        if let roomId = savedRoomId {
            room = roomRepo.getRoom(id: roomId)?.getId()
        } else {
            let rooms = roomRepo.getAllRooms()
            if rooms.count == 1 {
                room = rooms.first!.getId()
            }
        }
        return room
    }
}
