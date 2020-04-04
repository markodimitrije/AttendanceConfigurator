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
    
    @IBAction func settingsBtnTapped(_ sender: UIButton) {
        navigateToNextScreen()
    }
    
    lazy private var scanerViewModel = ScannerViewModelFactory.make()
    
    private (set) var scanedCode = BehaviorSubject<String>.init(value: "")
    var code: String {
        return try! scanedCode.value()
    }
    
    override var shouldAutorotate: Bool { return false }
    
    private let codeReporter = CodeReportsState.init() // vrsta viewModel-a ?
    private let delegatesSessionValidation = RealmDelegatesSessionValidation()
    
    private let realmInvalidAttedanceReportPersister = RealmInvalidAttedanceReportPersister(realmObjectPersister: RealmObjectPersister())
    
    private var settingsVC: SettingsVC!
    
    private var scanner: Scanning!
    
    // interna upotreba:
    fileprivate let disposeBag = DisposeBag()
    
    // MARK:- Controller Life cycle
    
    override func viewDidLoad() { super.viewDidLoad()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        loadScanner()
        
        sessionConstLbl.text = SessionTextData.sessionConst
        
        bindUI()
    }
    
    private func loadScanner() {
        scanner = Scanner(frame: self.scannerView.bounds, barcodeListener: self)
        self.scannerView.addSubview(scanner.captureView)
    }
    
    override func viewDidAppear(_ animated: Bool) { super.viewDidAppear(animated)
        scanner.startScanning()
    }
    
    override func viewDidDisappear(_ animated: Bool) { super.viewDidDisappear(animated)
        scanner.stopScanning()
    }
    
    private func bindUI() { // glue code for selected Room
        
        scanerViewModel.scannerInfoDriver
            .map {$0.getTitle()}
            .drive(sessionNameLbl.rx.text)
            .disposed(by: disposeBag)
        
        scanerViewModel.scannerInfoDriver
            .map {$0.getDescription()}
            .drive(sessionTimeAndRoomLbl.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK:- To next screen
    
    private func navigateToNextScreen() {
        let settingsVC = SettingsViewControllerFactory.make()
        let nextVC = UINavigationController(rootViewController: settingsVC)
        self.present(nextVC, animated: true)
    }
    
    // MARK:- Show Failed Alerts
    
    private func showAlertFailedDueToNoRoomOrSessionSettings() {
        
        self.alert(title: AlertInfo.Scan.NoSettings.title,
                   text: AlertInfo.Scan.NoSettings.msg,
                   btnText: AlertInfo.ok)
            .subscribe {
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    fileprivate func restartCameraForScaning() {
        delay(1.0) { // ovoliko traje anim kada prikazujes arrow
            DispatchQueue.main.async { [weak self] in
                guard let sSelf = self else {return}
                sSelf.scannerView.subviews.first(where: {$0.tag == 20})?.removeFromSuperview()
                sSelf.scanner.startScanning()
            }
        }
    }
    
    // MARK:- Barcode successfull
    
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
    }
    
    // MARK:- Delegate attendance
    
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
       
        print("getSessionReport = \(code)")
        
        return CodeReport(code: code,
                          sessionId: scanerViewModel.sessionId,
                          date: Date.now)
    }
    
}

// MARK: BarcodeListening

extension ScannerVC: BarcodeListening {
    
    func found(code: String) { // ovo mozes da report VM-u kao append novi code
        
        scanner.stopScanning()
        
        if scanerViewModel.sessionId != -1 {
            scanditSuccessfull(code: code)
        } else {
            showAlertFailedDueToNoRoomOrSessionSettings()
        }
        
        restartCameraForScaning()
        
    }
}
