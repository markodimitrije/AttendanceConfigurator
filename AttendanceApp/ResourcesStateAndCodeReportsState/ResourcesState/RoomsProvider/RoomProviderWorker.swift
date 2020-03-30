//
//  RoomProviderWorker.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 29/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

class RoomProviderWorker: IRoomProviderWorker {
    var apiController: IRoomApiController
    var repository: IRoomRepository
    private let bag = DisposeBag()
    init(apiController: IRoomApiController, repository: IRoomRepository) {
        self.apiController = apiController
        self.repository = repository
    }
    
    func fetchRoomsAndPersistOnDevice() -> Observable<Bool> {
        apiController.getRooms(updated_from: nil, with_pagination: 0, with_trashed: 0)
            .do(onNext: { (rooms) in
                self.repository.save(rooms: rooms)
            })
        .map {_ in true}
    }
}
