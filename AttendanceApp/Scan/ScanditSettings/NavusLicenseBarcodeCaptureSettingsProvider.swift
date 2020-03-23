//
//  NavusLicenseBarcodeCaptureSettingsProvider.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 23/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation
import ScanditBarcodeCapture

class NavusLicenseBarcodeCaptureSettingsProvider: BarcodeCaptureSettingsProviding {
    
    private let mySymbologies = Set<Symbology>.init(arrayLiteral:
        .aztec, .code128, .code25, .code39, .dataMatrix, .ean8, .ean13UPCA, .pdf417, .qr, .upce)
    
    var settings: BarcodeCaptureSettings
    
    init() {
        
        self.settings = BarcodeCaptureSettings()
        enableAllMySimbologies()
        expandBarcodeCharactersDefaultRange()
    }
    
    private func enableAllMySimbologies() {
        _ = mySymbologies.map { (simbology) in
            settings.set(symbology: simbology, enabled: true)
        }
    }
    
    private func expandBarcodeCharactersDefaultRange() {

        _ = self.mySymbologies.map {
                let symbologySettings = settings.settings(for: $0)
                let newActiveSymbolCounts = Set<NSNumber>.init(arrayLiteral: 2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25)
                symbologySettings.activeSymbolCounts = newActiveSymbolCounts
        }
    }
}
