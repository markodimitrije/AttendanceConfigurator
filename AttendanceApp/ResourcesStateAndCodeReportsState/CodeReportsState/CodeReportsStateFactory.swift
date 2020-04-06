//
//  CodeReportsStateFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 06/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class CodeReportsStateFactory {
    static func make() -> CodeReportsState {
        let apiController = CodeReportApiControllerFactory.make()
        let repository = CodeReportsRepositoryFactory.make()
        return CodeReportsState(apiController: apiController, repository: repository)
    }
}
