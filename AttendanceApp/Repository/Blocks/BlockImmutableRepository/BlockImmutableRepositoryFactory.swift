//
//  BlockImmutableRepositoryFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 07/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class BlockImmutableRepositoryFactory {
    static func make() -> IBlockImmutableRepository {
        return BlockImmutableRepository()
    }
}
