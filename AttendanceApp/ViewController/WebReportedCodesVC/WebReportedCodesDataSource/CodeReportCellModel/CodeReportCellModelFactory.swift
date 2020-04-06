//
//  CodeReportCellModelFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 06/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class CodeReportCellModelFactory {
    static func make(codeReport: ICodeReport) -> CodeReportCellModel {
        CodeReportCellModel(code: codeReport.getCode(),
                            reported: codeReport.isReported(),
                            accepted: codeReport.isAccepted())
    }
}
