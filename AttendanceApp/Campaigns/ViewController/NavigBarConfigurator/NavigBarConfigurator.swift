//
//  NavigBarConfigurator.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

struct NavigBarConfigurator: INavigBarConfigurator {
    func configure(navigationItem: UINavigationItem, btn: UIBarButtonItem) {
        navigationItem.hidesBackButton = true
        navigationItem.title = "SELECT CAMPAIGN"
        navigationItem.setRightBarButton(btn, animated: false)
    }
}
