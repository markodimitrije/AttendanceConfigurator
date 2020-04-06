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
        let barcode = codeReport.getCode()
        let sessionId = codeReport.getSessionId()
        
        object.id = barcode + "\(sessionId)"
        object.code = barcode
        object.sessionId = sessionId
        object.date = codeReport.getDate()
        object.reported = codeReport.isReported()
        object.accepted = codeReport.isAccepted()
        return object
    }
}
