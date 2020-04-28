//
//  LogoutHandler.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 28/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit
import RxSwift

class LogoutHandler: NSObject, ILogoutHandler {
    
    private let logoutWorker: ILogoutWorker
    private let alertInfo: AlertInfo
    private let bag = DisposeBag()
    init(logoutWorker: ILogoutWorker, alertInfo: AlertInfo) {
        self.logoutWorker = logoutWorker
        self.alertInfo = alertInfo
    }
    
    @objc func logoutTap() {
        
        UIViewController.topViewController()
            .alert(alertInfo: self.alertInfo, preferredStyle: .alert)
            .subscribe(onNext: { (tag) in
                switch tag {
                case 0: self.onLogoutConfirmed();
                case 1: print("dismisses alert")
                default: break
                }
            }).disposed(by: bag)
    }
    
    private func onLogoutConfirmed() {
        logoutWorker.logoutConfirmed()
        UIViewController.topViewController().navigationController?
            .popViewController(animated: true)
    }
}
