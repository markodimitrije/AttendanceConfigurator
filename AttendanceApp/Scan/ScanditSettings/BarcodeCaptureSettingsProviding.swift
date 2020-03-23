//
//  BarcodeCaptureSettingsProviding.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 12/07/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import ScanditBarcodeCapture

protocol BarcodeCaptureSettingsProviding {
    var settings: BarcodeCaptureSettings {get set}
}
