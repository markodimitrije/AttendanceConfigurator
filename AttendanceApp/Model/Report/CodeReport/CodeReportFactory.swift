//
//  CodeReportFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 31/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class CodeReportFactory {
    static func make(code: String,
                     blockId: Int,
                     date: Date,
                     accepted: Bool) -> ICodeReport {
        return CodeReport(code: code, blockId: blockId, date: date, accepted: accepted)
    }
    static func make(realmCodeReport: RealmCodeReport) -> ICodeReport {
        var codeReport = CodeReport(code: realmCodeReport.code,
                                    blockId: realmCodeReport.blockId,
                                    date: realmCodeReport.date,
                                    accepted: realmCodeReport.accepted)
        codeReport.reported = realmCodeReport.reported
        return codeReport
    }
}
