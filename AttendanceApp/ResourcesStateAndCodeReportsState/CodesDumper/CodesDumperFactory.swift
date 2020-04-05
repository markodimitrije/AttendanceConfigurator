//
//  CodesDumperFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 05/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class CodesDumperFactory {
    static func make() -> CodesDumper {
        let apiController = CodeReportApiControllerFactory.make()
        let repository = CodeReportsRepositoryFactory.make()
        return CodesDumper(apiController: apiController, repository: repository)
    }
}
