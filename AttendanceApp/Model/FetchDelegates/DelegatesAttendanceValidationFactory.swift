//
//  DelegatesAttendanceValidationFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 23/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class DelegatesAttendanceValidationFactory {
    static func make() -> IDelegatesAttendanceValidation {
        let blockRepo = BlockImmutableRepositoryFactory.make()
        let delegateRepo = DelegatesRepository(genericRepo: GenericRealmRepository())
        return DelegatesAttendanceValidation(blockRepo: blockRepo, delegateRepo: delegateRepo)
    }
}
