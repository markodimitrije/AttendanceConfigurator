//
//  AlertStateReporterFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 31/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class AlertStateReporterFactory {
    static func make() -> AlertStateReporter {
        let webAPI = ReportSessionApiControllerFactory.make()
        return AlertStateReporter(dataAccess: DataAccess.shared,
                                  monitor: AlertStateMonitor(),
                                  webAPI: webAPI)
    }
}
