//
//  CodeReportsPayloadFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 05/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class CodeReportsPayloadFactory {
    static func make(reports: [ICodeReport]) -> [String: Any] {
        let data = reports.map(makeSinglePayload)
        return ["data": data]
    }
    static func makeSinglePayload(report: ICodeReport) -> [String: Any] {
        return [
            "block_id": "\(report.getBlockId())",
            "code": trimmedToSixCharactersCode(code: report.getCode()),
            "time_of_scan": report.getDate().toString(format: Date.defaultFormatString) ?? ""
        ]
    }
}
