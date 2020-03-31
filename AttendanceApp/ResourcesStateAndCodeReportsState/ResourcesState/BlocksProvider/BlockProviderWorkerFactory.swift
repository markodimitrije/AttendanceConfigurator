//
//  BlockProviderWorkerFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 31/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class BlockProviderWorkerFactory {
    static func make(confId: Int) -> IBlockProviderWorker {
        let apiController = BlockApiController(apiController: ApiController.shared, confId: confId)
        let repo = BlockRepository()
        return BlockProviderWorker(apiController: apiController, repository: repo)
    }
}
