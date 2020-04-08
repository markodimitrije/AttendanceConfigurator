//
//  Model.swift
//  tryObservableWebApiAndRealm
//
//  Created by Marko Dimitrijevic on 19/10/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import RxDataSources

// ovaj struct treba za sectioned tableVC, implementacija dataSource-a iz lib "RxDataSources"

struct SectionOfCustomData {
    var header: String
    var items: [Item]
}

extension SectionOfCustomData: SectionModelType {
    typealias Item = BlockItem
    init(original: SectionOfCustomData, items: [Item]) {
        self = original
        self.items = items
    }
}

struct BlockItem {
    var name: String
    var date: Date
}

// RoomSection and RoomItem

struct RoomSectionOfCustomData {
    var header: String
    var items: [RoomItem]
}

extension RoomSectionOfCustomData: SectionModelType {
    typealias Item = RoomItem
    init(original: RoomSectionOfCustomData, items: [Item]) {
        self = original
        self.items = items
    }
}

struct RoomItem {
    var name: String
}


