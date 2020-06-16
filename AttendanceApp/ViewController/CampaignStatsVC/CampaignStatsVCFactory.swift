//
//  CampaignStatsVCFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 23/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class CampaignStatsVCFactory {
    static func make() -> CampaignStatsVC {
        let viewController = StoryboardedViewControllerFactory.make(type: CampaignStatsVC.self) as! CampaignStatsVC
        viewController.logoProvider = CampaignLogoProviderFactory.make()
        return viewController
    }
}
