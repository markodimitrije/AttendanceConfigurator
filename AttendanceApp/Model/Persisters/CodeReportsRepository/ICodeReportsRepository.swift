//
//  ICodeReportsRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 06/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

protocol ICodeReportsRepository {
    func getCodeReports() -> [ICodeReport]
    func getUnsynced() -> [ICodeReport]
    func getObsCodeReports() -> Observable<[ICodeReport]>
    func getObsUnsynced() -> Observable<[ICodeReport]>
    func deleteAllCodeReports() -> Observable<Bool>
    func saveToRealm(codeReport: ICodeReport) -> Observable<Bool>
    func update(codesAcceptedFromWeb: [ICodeReport]) -> Observable<Bool>
}
