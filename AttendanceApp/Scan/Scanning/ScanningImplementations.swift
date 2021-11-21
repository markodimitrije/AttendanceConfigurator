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

// MARK:- Scan Implementations

class ScanditScanner: NSObject, Scanning {
    
    weak var barcodeListener: BarcodeListening?
    var captureView: UIView
    
    private var camera: Camera!
    
    required init(frame: CGRect, barcodeListener: BarcodeListening) {
        
        self.barcodeListener = barcodeListener
        
        let context = DataCaptureContext(licenseKey: kScanditBarcodeScannerAppKey)
        let settings = NavusLicenseBarcodeCaptureSettingsProvider().settings
        let barcodeCapture = BarcodeCapture(context: context, settings: settings)
        
        let cameraPosition = getCameraDeviceDirection() ?? .worldFacing
        
        camera = Camera.init(position: cameraPosition)
        context.setFrameSource(camera, completionHandler: nil)
        
        camera?.switch(toDesiredState: .on)
        
        let captureView = DataCaptureView(for: context, frame: frame)
        
        captureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let overlay = BarcodeCaptureOverlay(barcodeCapture: barcodeCapture)
        captureView.addOverlay(overlay)
        
        self.captureView = captureView
        
        super.init()
        
        barcodeCapture.addListener(self)
    }
    
    func startScanning() {
        camera?.switch(toDesiredState: .on)
    }
    
    func stopScanning() {
        camera?.switch(toDesiredState: .off)
    }
}

extension ScanditScanner: BarcodeCaptureListener {
    func barcodeCapture(_ barcodeCapture: BarcodeCapture,
                        didScanIn session: BarcodeCaptureSession,
                        frameData: FrameData) {
        
        let code = session.newlyRecognizedBarcodes[0]
        
        DispatchQueue.main.async { [weak self] in
            
            self?.barcodeListener?.found(code: code.data)
            
        }
    }
}

import AVFoundation

class NativeScanner: NSObject, Scanning {
    
    weak var barcodeListener: BarcodeListening?
    var captureView: UIView
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    required init(frame: CGRect, barcodeListener: BarcodeListening) {
        
        self.barcodeListener = barcodeListener
        self.captureView = UIView(frame: frame)
        captureSession = AVCaptureSession()
        
        super.init()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
//            failed() marko
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
//            failed() marko
            return
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = frame
        previewLayer.videoGravity = .resizeAspectFill
        self.captureView.layer.addSublayer(previewLayer)
    }
    
    func startScanning() {
        captureSession.startRunning()
    }
    
    func stopScanning() {
        captureSession.stopRunning()
    }
}

extension NativeScanner: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {
                return
            }
            guard let codeValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            DispatchQueue.main.async { [weak self] in
                print("codeValue = \(codeValue)")
                self?.barcodeListener?.found(code: codeValue)
                
            }
        }
    }
}
