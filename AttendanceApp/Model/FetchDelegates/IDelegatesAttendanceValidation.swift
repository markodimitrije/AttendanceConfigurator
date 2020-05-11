//
//  IDelegatesAttendanceValidation.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 11/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

protocol IDelegatesAttendanceValidation {
    func isScannedDelegate(withBarcode code: String, blockId: Int) -> Bool
}
