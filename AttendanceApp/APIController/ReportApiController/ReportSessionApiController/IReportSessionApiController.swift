//
//  IReportSessionApiController.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 31/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

protocol IReportSessionApiController {
    func reportSelectedSession(report: SessionReport?) -> Observable<(SessionReport,Bool)> // TODO marko vrati samo Void-ok ili error
}
