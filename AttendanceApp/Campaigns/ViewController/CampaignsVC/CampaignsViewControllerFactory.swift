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
        campaignsVC.viewModel = CampaignsViewModelFactory.make()
        campaignsVC.navBarConfigurator = NavigBarConfigurator()
        campaignsVC.logoutHandler = LogoutHandlerFactory.make()
        campaignsVC.campaignSelectionRepo = CampaignSelectionRepositoryFactory.make()
        return campaignsVC
    }
}
