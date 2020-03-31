//
//  DelegateProviderWorkerFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 31/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class DelegateProviderWorkerFactory {
    static func make(confId: Int) -> IDelegateProviderWorker {
        let apiController = ApiController.shared
        let unziper = Unziper(conferenceId: confId)
        let delegatesApi = DelegatesAPIController(apiController: apiController, unziper: unziper)
        return DelegateProviderWorker(apiController: delegatesApi,
                                      repository: RealmDelegatesPersister.shared)
    }
}
