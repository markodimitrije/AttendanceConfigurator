//
//  CampaignsViewControllerFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

class CampaignsViewControllerFactory {
    static func make() -> CampaignsVC {
        let campaignsVC = StoryboardedViewControllerFactory.make(type: CampaignsVC.self) as! CampaignsVC
        campaignsVC.logoutWorker = LogoutWorkerFactory.make()
        campaignsVC.campaignsViewModel = CampaignsViewModelFactory.make()
        campaignsVC.navBarConfigurator = NavigBarConfigurator()
        campaignsVC.alertInfo = LogoutAlertInfoFactory.make()
        return campaignsVC
    }
}
