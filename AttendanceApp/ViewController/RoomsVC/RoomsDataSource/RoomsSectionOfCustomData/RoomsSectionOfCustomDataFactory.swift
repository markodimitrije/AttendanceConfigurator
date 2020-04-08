//
//  RoomsSectionOfCustomDataFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 08/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class RoomsSectionOfCustomDataFactory {
    static func make(rooms: [IRoom]) -> [RoomsSectionOfCustomData] {
        let items = rooms.map {RoomsSectionOfCustomData.Item(name: $0.getName())}
        return [RoomsSectionOfCustomData(header: "", items: items)]
    }
}
