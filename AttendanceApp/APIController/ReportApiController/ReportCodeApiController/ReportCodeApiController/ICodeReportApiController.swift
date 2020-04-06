//
//  ICodeReportApiController.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 31/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

// TODO marko -> only multiple codes should exist - remove single code report

protocol ICodeReportApiController {
    func reportSingleCode(report: ICodeReport) -> Observable<(ICodeReport, Bool)> // TODO marko just ()
    func reportMultipleCodes(reports: [ICodeReport]) -> Observable<Bool> // isto...
}
