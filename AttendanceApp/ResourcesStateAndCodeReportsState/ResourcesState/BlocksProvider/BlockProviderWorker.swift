//
//  BlockProviderWorker.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 29/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class BlockProviderWorker: IBlockProviderWorker {
    var apiController: IBlockApiController
    var repository: IBlockRepository
    init(apiController: IBlockApiController, repository: IBlockRepository) {
        self.apiController = apiController
        self.repository = repository
    }
    
    func fetchBlocksAndPersistOnDevice() {
        apiController.getBlocks() // hard-coded, implement me
    }
}
