//
//  ScannerViewModelFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 04/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class ScannerViewModelFactory {
    static func make() -> ScannerViewModel {
        let blockRepo = BlockImmutableRepositoryFactory.make()
        let scannerInfoFactory = ScannerInfoFactory(roomRepo: RoomRepository(), blockRepo: blockRepo, blockPresenter: BlockPresenter())
        let codeReportsState = CodeReportsStateFactory.make()
        return ScannerViewModel(dataAccess: DataAccess.shared,
                                scannerInfoFactory: scannerInfoFactory,
                                codeReportsState: codeReportsState)
    }
}
