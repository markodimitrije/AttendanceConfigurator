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

//extension Campaign: Equatable {
//    static func == (lhs: Self, rhs: Self) -> Bool {
//        lhs.id == rhs.id &&
//        lhs.name == rhs.name &&
//        lhs.description == rhs.description &&
//        lhs.logo == rhs.logo &&
//        lhs.conferenceId == rhs.conferenceId &&
//        lhs.restrictedAccess == rhs.restrictedAccess &&
//        lhs.createdAt == rhs.createdAt &&
//        lhs.updatedAt == rhs.updatedAt &&
//        lhs.deletedAt == rhs.deletedAt &&
//        lhs.image == rhs.image
//    }
//}
