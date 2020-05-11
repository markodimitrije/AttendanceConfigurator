//
//  ReportBlockApiControllerFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 31/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class ReportBlockApiControllerFactory {
    static func make() -> IReportBlockApiController {
        return ReportBlockApiController(apiController: ApiController.shared)
    }
}
