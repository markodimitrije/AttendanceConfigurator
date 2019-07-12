//
//  ScannerVC.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 22/10/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation
import RealmSwift

import ScanditCaptureCore
import ScanditBarcodeCapture

class ScannerVC: UIViewController {

    @IBOutlet weak var scannerView: UIView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var sessionConstLbl: UILabel!
    @IBOutlet weak var sessionNameLbl: UILabel!
    @IBOutlet weak var sessionTimeAndRoomLbl: UILabel!
    
    lazy private var scanerViewModel = ScannerViewModel.init(dataAccess: DataAccess.shared)
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    private (set) var scanedCode = BehaviorSubject<String>.init(value: "")
    var code: String {
        return try! scanedCode.value()
    }
    
    private let codeReporter = CodeReportsState.init() // vrsta viewModel-a ?
    private let delegatesSessionValidation = RealmDelegatesSessionValidation()
    
    private let realmInvalidAttedanceReportPersister = RealmInvalidAttedanceReportPersister(realmObjectPersister: RealmObjectPersister())
    
    var settingsVC: SettingsVC!
    
    private var camera: Camera?
    
    // interna upotreba:
    private let disposeBag = DisposeBag()
    
    // MARK:- Controller Life cycle
    
    override func viewDidLoad() { super.viewDidLoad()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        setupScanner()
        
        sessionConstLbl.text = SessionTextData.sessionConst
        bindUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) { super.viewDidAppear(animated)
        camera?.switch(toDesiredState: .on)
    }
    
    override func viewDidDisappear(_ animated: Bool) { super.viewDidDisappear(animated)
        camera?.switch(toDesiredState: .off)
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    private func bindUI() { // glue code for selected Room
        
        scanerViewModel.sessionName//.map {$0+$0} (test text length) // SESSION NAME
            .bind(to: sessionNameLbl.rx.text)
            .disposed(by: disposeBag)
        
        scanerViewModel.sessionInfo // SESSION INFO
            .bind(to: sessionTimeAndRoomLbl.rx.text)
            .disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let name = segue.identifier, name == "segueShowSettings",
            let navVC = segue.destination as? UINavigationController,
            let settingsVC = navVC.children.first as? SettingsVC else { return }
        
        self.settingsVC = settingsVC
        
        hookUpScanedCode(on: settingsVC)
        
    }
    
    private func hookUpScanedCode(on settingsVC: SettingsVC) {
        
        settingsVC.codeScaned = self.scanedCode
        
    }
    
    private func failed() { print("failed.....")

        self.alert(title: AlertInfo.Scan.ScanningNotSupported.title,
                   text: AlertInfo.Scan.ScanningNotSupported.msg,
                   btnText: AlertInfo.ok)
            .subscribe {
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func showAlertFailedDueToNoRoomOrSessionSettings() {
        
        self.alert(title: AlertInfo.Scan.NoSettings.title,
                   text: AlertInfo.Scan.NoSettings.msg,
                   btnText: AlertInfo.ok)
            .subscribe {
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func found(code: String) { // ovo mozes da report VM-u kao append novi code
        
        if scanerViewModel.sessionId != -1 {
            scanditSuccessfull(code: code)
        } else {
            showAlertFailedDueToNoRoomOrSessionSettings()
            restartCameraForScaning()
        }
        
    }
    
    fileprivate func restartCameraForScaning() {
        delay(1.0) { // ovoliko traje anim kada prikazujes arrow
            DispatchQueue.main.async {
                self.scannerView.subviews.first(where: {$0.tag == 20})?.removeFromSuperview()
                self.camera?.switch(toDesiredState: .on)
            }
        }
    }
    
    private func scanditSuccessfull(code: String) { // hard-coded implement me
        
        if self.scannerView.subviews.contains(where: {$0.tag == 20}) { return } // already arr on screen...
        
        // hard-coded off - main event
        if delegatesSessionValidation.isScannedDelegate(withBarcode: code,
                                                        allowedToAttendSessionWithId: scanerViewModel.sessionId) {
            delegateIsAllowedToAttendSession(code: code)
        } else {
            delegateAttendanceInvalid(code: code)
        }
        // hard-coded on
//        delegateIsAllowedToAttendSession(code: code)
        restartCameraForScaning()
    }
    
    private func delegateIsAllowedToAttendSession(code: String) {
        
        scanedCode.onNext(code)
        playSound(name: "codeSuccess")
        self.scannerView.addSubview(getArrowImgView(frame: scannerView.bounds, validAttendance: true))
        codeReporter.codeReport.accept(getActualCodeReport())
    }
    
    private func delegateAttendanceInvalid(code: String) {
        persistInAttendanceInvalid(code: code)
        uiEffectsForAttendanceInvalid()
    }
    
    private func persistInAttendanceInvalid(code: String) {
        realmInvalidAttedanceReportPersister
            .saveToRealm(invalidAttendanceCode: code)
            .subscribe(onNext: { success in
                print("invalid codes saved = \(success)")
            }).disposed(by: disposeBag)
    }
    
    private func uiEffectsForAttendanceInvalid() {
        playSound(name: "codeRejected")
        self.scannerView.addSubview(getArrowImgView(frame: scannerView.bounds, validAttendance: false))
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape //[.landscapeLeft, .landscapeRight]
    }
    
    // MARK:- Private
    
    private func getActualCodeReport() -> CodeReport {
       
        print("getActualCodeReport = \(code)")
        
        return CodeReport.init(code: code,
                               sessionId: scanerViewModel.sessionId,
                               date: Date.now)
    }
    
    
    // SCANDIT
    
    private func setupScanner() {
        
        let context = DataCaptureContext(licenseKey: kScanditBarcodeScannerAppKey)
        let settings = NavusLicenseBarcodeCaptureSettingsProvider().settings

        let barcodeCapture = BarcodeCapture(context: context, settings: settings)
        
        barcodeCapture.addListener(self)
        
        let cameraPosition = getCameraDeviceDirection() ?? .worldFacing
        
        camera = Camera.init(position: cameraPosition)
        context.setFrameSource(camera, completionHandler: nil)
        
        camera?.switch(toDesiredState: .on)
        
        let captureView = DataCaptureView(frame: self.scannerView.bounds)
        captureView.context = context
        captureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(captureView)
        
        let overlay = BarcodeCaptureOverlay(barcodeCapture: barcodeCapture)
        captureView.addOverlay(overlay)
        
        self.scannerView.addSubview(captureView)
        
    }
    
}

extension ScannerVC: BarcodeCaptureListener {
    func barcodeCapture(_ barcodeCapture: BarcodeCapture,
                        didScanIn session: BarcodeCaptureSession,
                        frameData: FrameData) {

        camera?.switch(toDesiredState: .off)
        
        let code = session.newlyRecognizedBarcodes[0]
        
        DispatchQueue.main.async { [weak self] in
            self?.found(code: code.data)
        }
    }
}

protocol BarcodeCaptureSettingsProviding {
    var settings: BarcodeCaptureSettings {get set}
}

class NavusLicenseBarcodeCaptureSettingsProvider: BarcodeCaptureSettingsProviding {
    var settings: BarcodeCaptureSettings
    init() {
        
        let settings = BarcodeCaptureSettings()
        
        settings.set(symbology: .aztec, enabled: true)
        settings.set(symbology: .code128, enabled: true)
        settings.set(symbology: .code25, enabled: true)
        settings.set(symbology: .code39, enabled: true)
        settings.set(symbology: .dataMatrix, enabled: true)
        settings.set(symbology: .ean8, enabled: true)
        settings.set(symbology: .ean13UPCA, enabled: true)
        settings.set(symbology: .pdf417, enabled: true)
        settings.set(symbology: .qr, enabled: true)
        settings.set(symbology: .upce, enabled: true)
        
        self.settings = settings
    }
}


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
