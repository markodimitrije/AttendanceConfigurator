//
//  BlockMutableRepositoryFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 07/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class BlockMutableRepositoryFactory {
    static func make() -> IBlockMutableRepository {
        return BlockMutableRepository()
    }
}
