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
        scannerVC.viewModel = ScannerViewModelFactory.make()
        return scannerVC
    }
}
