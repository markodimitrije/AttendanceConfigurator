//
//  ICodeReportsMutableRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 12/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

protocol ICodeReportsMutableRepository {
    func deleteAllCodeReports() -> Observable<Bool>
    func save(codeReport: ICodeReport) -> Observable<Bool>
    func update(codesAcceptedFromWeb: [ICodeReport]) -> Observable<Bool>
}
