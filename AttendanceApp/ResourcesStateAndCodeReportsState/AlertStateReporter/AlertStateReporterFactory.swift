//
//  AlertStateReporterFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 31/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class AlertStateReporterFactory {
    static func make() -> AlertStateReporter {
        return AlertStateReporter(dataAccess: DataAccess.shared,
                                  monitor: AlertStateMonitor(),
                                  webAPI: ApiController.shared)
    }
}
