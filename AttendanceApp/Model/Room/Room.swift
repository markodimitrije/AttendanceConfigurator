//
//  Room.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 22/10/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol IRoom {
    func getId() -> Int
    func getOrder() -> Int
    func getName() -> String
}

struct Rooms: Codable {
    var data: [Room]
}

extension Room: IRoom {
    func getId() -> Int {self.id}
    func getOrder() -> Int {self.order}
    func getName() -> String {self.name}
}

struct Room: Codable {
    var id: Int
    var name: String
    var order: Int
    init(from realRoom: RealmRoom) {
        self.id = realRoom.id
        self.name = realRoom.name
        self.order = realRoom.order
    }
}
