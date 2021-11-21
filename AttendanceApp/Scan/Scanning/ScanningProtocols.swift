//
//  ScanningProtocols.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 12/07/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import UIKit

protocol BarcodeListening: class {
    func found(code: String)
}

// MARK:- Scan Protocols

protocol ScanTrafficking {
    func startScanning()
    func stopScanning()
}
protocol ScanedBarcodeForwarding: class {
    //var barcodeListener: BarcodeListening {get set}
    var barcodeListener: BarcodeListening? {get set}
}
protocol ScanInitializing {
    init(frame: CGRect, barcodeListener: BarcodeListening)
}
protocol ScanViewProviding {
    var captureView: UIView {get set} // view to be added to VCs placeholder view
}

protocol Scanning: ScanTrafficking, ScanedBarcodeForwarding, ScanInitializing, ScanViewProviding {}
