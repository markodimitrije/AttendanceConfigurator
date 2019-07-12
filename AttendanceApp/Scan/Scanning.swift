//
//  Scanning.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 12/07/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import UIKit
import ScanditCaptureCore
import ScanditBarcodeCapture


protocol Scanning { // view for scanning with camera
    var captureView: UIView {get set} // view to be added to VCs placeholder view
    init(frame: CGRect, barcodeListener: BarcodeCaptureListener)
    func startScanning()
    func stopScanning()
}

class Scanner: Scanning {
    
    private var camera: Camera!
    var captureView: UIView
    
    required init(frame: CGRect, barcodeListener: BarcodeCaptureListener) {
        let context = DataCaptureContext(licenseKey: kScanditBarcodeScannerAppKey)
        let settings = NavusLicenseBarcodeCaptureSettingsProvider().settings
        let barcodeCapture = BarcodeCapture(context: context, settings: settings)
        
        barcodeCapture.addListener(barcodeListener)
        
        let cameraPosition = getCameraDeviceDirection() ?? .worldFacing
        
        camera = Camera.init(position: cameraPosition)
        context.setFrameSource(camera, completionHandler: nil)
        
        camera?.switch(toDesiredState: .on)
        
        //let captureView = DataCaptureView(frame: self.scannerView.bounds)
        let captureView = DataCaptureView(for: context, frame: frame)
        
        captureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let overlay = BarcodeCaptureOverlay(barcodeCapture: barcodeCapture)
        captureView.addOverlay(overlay)
        
        self.captureView = captureView
    }
    
    func startScanning() {
        camera.switch(toDesiredState: .on)
    }
    
    func stopScanning() {
        camera.switch(toDesiredState: .off)
    }
}
