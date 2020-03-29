//
//  RoomProviderWorker.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 29/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class RoomProviderWorker: IRoomProviderWorker {
    var apiController: IRoomApiController
    var repository: IRoomRepository
    init(apiController: IRoomApiController, repository: IRoomRepository) {
        self.apiController = apiController
        self.repository = repository
    }
    
    func fetchRoomsAndPersistOnDevice() {
        apiController.getRooms() // hard-coded, implement me
    }
}
