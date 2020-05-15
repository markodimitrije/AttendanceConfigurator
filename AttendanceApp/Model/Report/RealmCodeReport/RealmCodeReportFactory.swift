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
        let date = codeReport.getDate()
        
        object.id = date.toString() ?? ""
        object.code = codeReport.getCode()
        object.campaignId = codeReport.getCampaignId()
        object.blockId = codeReport.getBlockId()
        object.date = date
        object.reported = codeReport.isReported()
        object.accepted = codeReport.isAccepted()
        return object
    }
}
