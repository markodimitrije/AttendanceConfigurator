//
//  RealmCodeReportFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 31/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class RealmCodeReportFactory {
    
    static func make(with codeReport: ICodeReport) -> RealmCodeReport {
        let object = RealmCodeReport()
        object.code = codeReport.getCode()
        object.sessionId = codeReport.getSessionId()
        object.date = codeReport.getDate()
        return object
    }
}
