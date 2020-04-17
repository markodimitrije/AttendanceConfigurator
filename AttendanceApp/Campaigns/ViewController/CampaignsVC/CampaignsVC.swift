//
//  CampaignsVC.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

class CampaignsVC: UIViewController, Storyboarded {
    
    var logoutWorker: ILogoutWorker!
    var navBarConfigurator: INavigBarConfigurator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarConfigurator.configure(navigationItem: navigationItem)
    }
    
    @objc func logoutTap() {
        print("display alert if confirmed, notify viewmodel...")
        logoutWorker.logoutConfirmed() //hard-coded
        
        onLogoutConfirmed()
    }
    
    private func onLogoutConfirmed() {
        navigationController?.popViewController(animated: true)
    }
    
    
}
