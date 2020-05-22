//
//  AlertStateReporterFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 31/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class AlertStateReporterFactory {
    static func make() -> AlertStateReporter {
        let webAPI = ReportBlockApiControllerFactory.make()
        
        let scanSettingsRepo = ScanSettingsRepositoryFactory.make()
        return AlertStateReporter(scanSettingsRepo: scanSettingsRepo,
                                  monitor: AlertStateMonitor(),
                                  webAPI: webAPI)
    }
}
