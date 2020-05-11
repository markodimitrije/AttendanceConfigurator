//
//  IScanningInfoProviding.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 04/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxCocoa

protocol IScanningInfoProviding {
    func getScannerInfoDriver() -> SharedSequence<DriverSharingStrategy, IScannerInfo>
    func getActualBlockId() -> Int
}
