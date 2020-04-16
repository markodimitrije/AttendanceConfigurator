//
//  CampaignsVC.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

class CampaignsVC: UIViewController, Storyboarded {
    
//    var logout: UIVi
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationItem.title = "CAMPAIGNS"
        //navigationItem.setRightBarButton(<#T##item: UIBarButtonItem?##UIBarButtonItem?#>, animated: <#T##Bool#>)
    }
}
