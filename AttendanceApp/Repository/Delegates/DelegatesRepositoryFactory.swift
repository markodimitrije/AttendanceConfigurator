//
//  DelegatesRepositoryFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 05/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class DelegatesRepositoryFactory {
    static func make() -> IDelegatesRepository {
        return DelegatesRepository(genericRepo: GenMuttableRepository())
    }
}
