//
//  ResourceStateFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 31/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class ResourceStateFactory {
    static func make(confId: Int) -> ResourcesState {
        let object =
            ResourcesState(roomProviderWorker: RoomProviderWorkerFactory.make(confId: confId),
                           blockProviderWorker: BlockProviderWorkerFactory.make(confId: confId),
                           delegateProviderWorker: DelegateProviderWorkerFactory.make(confId: confId))
        return object
    }
}
