//
//  RoomsViewModelFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 08/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class RoomsViewModelFactory {
    static func make() -> IRoomsViewModel {
        return RoomsViewModel(roomRepository: RoomRepository())
    }
}
