//
//  BlocksSectionOfCustomData.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 08/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxDataSources

struct BlocksSectionOfCustomData {
    var header: String
    var items: [Item]
}

extension BlocksSectionOfCustomData: SectionModelType {
    typealias Item = BlockItem
    init(original: BlocksSectionOfCustomData, items: [Item]) {
        self = original
        self.items = items
    }
}

struct BlockItem {
    var name: String
    var date: Date
}
