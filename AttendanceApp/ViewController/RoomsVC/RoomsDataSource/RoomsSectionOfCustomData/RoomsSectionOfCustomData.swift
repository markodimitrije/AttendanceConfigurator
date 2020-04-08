//
//  RoomsSectionOfCustomData.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 08/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxDataSources

struct RoomsSectionOfCustomData {
    var header: String
    var items: [RoomItem]
}

extension RoomsSectionOfCustomData: SectionModelType {
    typealias Item = RoomItem
    init(original: RoomsSectionOfCustomData, items: [Item]) {
        self = original
        self.items = items
    }
}

struct RoomItem {
    var name: String
}
