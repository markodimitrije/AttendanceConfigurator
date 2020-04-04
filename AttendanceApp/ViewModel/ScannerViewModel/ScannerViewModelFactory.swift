//
//  ScannerViewModelFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 04/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class ScannerViewModelFactory {
    static func make() -> ScannerViewModel {
        let scannerInfoFactory = ScannerInfoFactory(roomRepo: RoomRepository(), blockRepo: BlockRepository(), blockPresenter: BlockPresenter())
        return ScannerViewModel(dataAccess: DataAccess.shared,
                                scannerInfoFactory: scannerInfoFactory)
    }
}
