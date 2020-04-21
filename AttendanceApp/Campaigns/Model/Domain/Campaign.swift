//
//  Campaign.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

struct Campaign: ICampaign {
    var id = 0
    var name = ""
    var description = ""
    var logo = ""
    var createdAt = Date.init(timeIntervalSince1970: 0)
    var image: UIImage? = CAMPAIGN_DEF_IMG
}
