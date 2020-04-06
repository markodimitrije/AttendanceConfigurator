//
//  UnsyncScansViewModelFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 06/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxCocoa

class UnsyncScansViewModelFactory {
    static func make(syncScansTap: Driver<()>) -> UnsyncScansViewModel {
        let repository = CodeReportsRepositoryFactory.make()
        return UnsyncScansViewModel(syncScans: syncScansTap, codeReportsRepository: repository)
    }
}
