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
        let blockId = codeReport.getBlockId()
        
        object.id = barcode + "\(blockId)"
        object.code = barcode
        object.blockId = blockId
        object.date = codeReport.getDate()
        object.reported = codeReport.isReported()
        object.accepted = codeReport.isAccepted()
        return object
    }
}
