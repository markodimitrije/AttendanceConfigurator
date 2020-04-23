//
//  DelegatesSessionValidationFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 23/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class DelegatesSessionValidationFactory {
    static func make() -> IDelegatesSessionValidation {
        let blockRepo = BlockImmutableRepositoryFactory.make()
        let delegateRepo = DelegatesRepository(genericRepo: GenericRealmRepository())
        return DelegatesSessionValidation(blockRepo: blockRepo, delegateRepo: delegateRepo)
    }
}
