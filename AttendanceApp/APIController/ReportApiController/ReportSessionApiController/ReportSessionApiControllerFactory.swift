//
//  ReportSessionApiControllerFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 31/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class ReportSessionApiControllerFactory {
    static func make() -> IReportSessionApiController {
        return ReportSessionApiController(apiController: ApiController.shared)
    }
}
