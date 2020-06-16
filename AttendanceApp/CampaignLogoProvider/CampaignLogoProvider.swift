//
//  CampaignLogoProvider.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/06/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

protocol ICampaignLogoProvider {
    func getLogo() -> UIImageView
}

extension CampaignLogoProvider: ICampaignLogoProvider {
    func getLogo() -> UIImageView {
        let selCampaignId = campaignSelectionRepo.getSelected()?.getCampaignId()
        let campaign = campaignsRepo.getAll().first(where: {$0.id == selCampaignId})
        let imgView = imageProvider.get(addr: campaign?.logo)
        imgView.contentMode = .scaleAspectFit
        return imgView
    }
}

struct CampaignLogoProvider {
    let campaignSelectionRepo: ICampaignSelectionRepository
    let campaignsRepo: ICampaignsImmutableRepository
    let imageProvider: IImageProvider
}
