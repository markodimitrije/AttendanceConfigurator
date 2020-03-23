//
//  BarcodeCaptureSettingsProvider.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 23/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation
import ScanditBarcodeCapture

class BarcodeCaptureSettingsProvider: BarcodeCaptureSettingsProviding {
    var settings: BarcodeCaptureSettings
    init() {
        
        let settings = BarcodeCaptureSettings()
        
        settings.set(symbology: .codabar, enabled: true)
        settings.set(symbology: .code11, enabled: true)
        settings.set(symbology: .code25, enabled: true)
        settings.set(symbology: .code32, enabled: true)
        settings.set(symbology: .code39, enabled: true)
        settings.set(symbology: .code93, enabled: true)
        settings.set(symbology: .code128, enabled: true)
        settings.set(symbology: .codabar, enabled: true)
        settings.set(symbology: .interleavedTwoOfFive, enabled: true)
        settings.set(symbology: .dataMatrix, enabled: true)
        settings.set(symbology: .ean8, enabled: true)
        settings.set(symbology: .ean13UPCA, enabled: true)
        settings.set(symbology: .upce, enabled: true)
        settings.set(symbology: .msiPlessey, enabled: true)
        settings.set(symbology: .qr, enabled: true)
        settings.set(symbology: .microQR, enabled: true)
        settings.set(symbology: .microPDF417, enabled: true)
        settings.set(symbology: .pdf417, enabled: true)
        settings.set(symbology: .aztec, enabled: true)
        settings.set(symbology: .maxiCode, enabled: true)
        settings.set(symbology: .dotCode, enabled: true)
        settings.set(symbology: .kix, enabled: true)
        settings.set(symbology: .rm4scc, enabled: true)
        settings.set(symbology: .gs1Databar, enabled: true)
        settings.set(symbology: .gs1DatabarExpanded, enabled: true)
        settings.set(symbology: .gs1DatabarLimited, enabled: true)
        settings.set(symbology: .lapa4SC, enabled: true)
        
        self.settings = settings
    }
}
