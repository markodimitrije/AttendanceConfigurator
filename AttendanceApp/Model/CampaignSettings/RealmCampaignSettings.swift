//
//  RealmCampaignSettings.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 21/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RealmSwift

class RealmCampaignSettings: Object {
    @objc dynamic var campaignId = ""
    @objc dynamic var roomId: String?
    @objc dynamic var blockId: String?
    @objc dynamic var date: Date?
    @objc dynamic var autoSwitch = true
    
    override class func primaryKey() -> String? {
        "campaignId"
    }
}
