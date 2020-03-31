//
//  RoomProviderWorkerFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 31/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class RoomProviderWorkerFactory {
    static func make(confId: Int) -> IRoomProviderWorker {
        let apiController = RoomApiController(apiController: ApiController.shared, confId: confId)
        let roomRepo = RoomRepository()
        return RoomProviderWorker(apiController: apiController, repository: roomRepo)
    }
}
