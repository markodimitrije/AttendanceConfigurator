//
//  NavigBarConfigurator.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

class NavigBarConfigurator: INavigBarConfigurator {
    func configure(navigationItem: UINavigationItem) {
        navigationItem.hidesBackButton = true
        navigationItem.title = "CAMPAIGNS"
        let btn = LogoutButtonFactory.make(target: self)
        navigationItem.setRightBarButton(btn, animated: false)
    }
}
