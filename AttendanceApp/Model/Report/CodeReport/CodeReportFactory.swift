//
//  CodeReportFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 31/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class CodeReportFactory {
    static func make(code: String, sessionId: Int, date: Date) -> ICodeReport {
        return CodeReport(code: code, sessionId: sessionId, date: date)
    }
    static func make(realmCodeReport: RealmCodeReport) -> ICodeReport {
        
        return CodeReport(code: realmCodeReport.code,
                          sessionId: realmCodeReport.sessionId,
                          date: realmCodeReport.date)
    }
}
