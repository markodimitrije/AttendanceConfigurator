//
//  CampaignSettings.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 19/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

struct CampaignSettings: ICampaignSettings {
    var roomId: Int?
    var blockId: Int?
    var selectedDate: Date?
    var autoSwitch: Bool
    init(roomId: Int? = nil, blockId: Int? = nil, selDate: Date? = nil, autoSwitch: Bool = true) {
        self.roomId = roomId
        self.blockId = blockId
        self.selectedDate = selDate
        self.autoSwitch = autoSwitch
    }
    init(settings: [String: Any]?) {
        self.roomId = settings?["roomId"] as? Int
        self.blockId = settings?["blockId"] as? Int
        self.selectedDate = settings?["date"] as? Date
        self.autoSwitch = settings?["autoSwitch"] as? Bool ?? true
    }
}
