//
//  ICodeReportsRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 06/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

protocol ICodeReportsImmutableRepository {
    func getCodeReports() -> [ICodeReport]
    func getUnsynced() -> [ICodeReport]
    func getObsCodeReports() -> Observable<[ICodeReport]>
    func getObsUnsynced() -> Observable<[ICodeReport]>
}

protocol ICodeReportsQueryImmutableRepository: ICodeReportsImmutableRepository {
    func getTotalScansCount() -> Int
    func getApprovedScansCount() -> Int
    func getRejectedScansCount() -> Int
    func getSyncedScansCount() -> Int
}

protocol ICodeReportsMutableRepository {
    func deleteAllCodeReports() -> Observable<Bool>
    func save(codeReport: ICodeReport) -> Observable<Bool>
    func update(codesAcceptedFromWeb: [ICodeReport]) -> Observable<Bool>
}

protocol ICodeReportsRepository: ICodeReportsQueryImmutableRepository, ICodeReportsMutableRepository {}
