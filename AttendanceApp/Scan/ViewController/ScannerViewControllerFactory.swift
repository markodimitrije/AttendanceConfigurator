//
//  ScannerViewControllerFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 22/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class ScannerViewControllerFactory {
    static func make() -> ScannerViewController {
        let scannerVC = StoryboardedViewControllerFactory.make(type: ScannerViewController.self) as! ScannerViewController
        let viewModel = ScannerViewModelFactory.make()
        viewModel.delegate = scannerVC // by weak var
        scannerVC.viewModel = viewModel
        scannerVC.delegatesAttendanceValidation = DelegatesAttendanceValidationFactory.make()
        scannerVC.alertInfoFactory = ScannerSettingsAlertInfoFactory()
        return scannerVC
    }
}
