//
//  RealmCampaign.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 21/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RealmSwift

class RealmCampaign: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var logo: String = ""
    @objc dynamic var createdAt: Date = Date.init(timeIntervalSince1970: 0)
    @objc dynamic var image: Data = CAMPAIGN_DEF_IMG.pngData()!
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
