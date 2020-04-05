//
//  CodeReportsRepositoryFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 05/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class CodeReportsRepositoryFactory {
    static func make() -> ICodeReportsRepository {
        return CodeReportsRepository(genericRepo: GenericRealmRepository())
    }
}
