//
//  Campaign.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

struct Campaign: ICampaign {
    var id = ""
    var name = ""
    var description: String?
    var logo: String?
    var conferenceId: Int
    var restrictedAccess: Bool
    var createdAt = Date.init(timeIntervalSince1970: 0)
    var updatedAt: Date?
    var deletedAt: Date?
    var image: UIImage? = CAMPAIGN_DEF_IMG
}
