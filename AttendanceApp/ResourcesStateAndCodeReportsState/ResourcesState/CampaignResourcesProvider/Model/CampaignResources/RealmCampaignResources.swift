//
//  RealmCampaignResources.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RealmSwift

class RealmCampaignResources: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var confDataVersion: Int = 0
    let rooms = List<RealmRoom>()
    let blocks = List<RealmBlock>()
    let delegates = List<RealmDelegate>()
    
    override class func primaryKey() -> String? { "id" }
}
