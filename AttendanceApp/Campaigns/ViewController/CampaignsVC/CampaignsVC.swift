//
//  CampaignsVC.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit
import RxSwift

class CampaignsVC: UIViewController, Storyboarded {
    
    var logoutWorker: ILogoutWorker!
    var navBarConfigurator: INavigBarConfigurator!
    var alertInfo: AlertInfo!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarConfigurator.configure(navigationItem: navigationItem, viewController: self)
    }
    
    @objc func logoutTap() {
        
        alert(alertInfo: self.alertInfo, preferredStyle: .alert)
            .subscribe(onNext: { (tag) in
                switch tag {
                case 0: print("dismisses alert")
                case 1: self.onLogoutConfirmed();
                default: break
                }
            }).disposed(by: bag)
    }
    
    private func onLogoutConfirmed() {
        logoutWorker.logoutConfirmed()
        navigationController?.popViewController(animated: true)
    }
    
}
