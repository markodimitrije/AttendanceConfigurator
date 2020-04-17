//
//  NavigBarConfigurator.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

class NavigBarConfigurator: INavigBarConfigurator {
    func configure(navigationItem: UINavigationItem, viewController: UIViewController) {
        navigationItem.hidesBackButton = true
        navigationItem.title = "CAMPAIGNS"
        let btn = LogoutButtonFactory().make(target: viewController)
        navigationItem.setRightBarButton(btn, animated: false)
    }
}
