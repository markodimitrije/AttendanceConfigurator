//
//  ICodeReportsImmutableRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 12/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

protocol ICodeReportsImmutableRepository {
    func getCodeReports() -> [ICodeReport]
    func getUnsynced() -> [ICodeReport]
    func getObsCodeReports() -> Observable<[ICodeReport]>
    func getObsUnsynced() -> Observable<[ICodeReport]>
}
